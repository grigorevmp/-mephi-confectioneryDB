Процедуры:

1. 
Вх: Номер заказа
Рассчитать стоимость заказа: вся продукция, топпинги
Включить запись в таблицу
При добавлении нового заказа: рассчитать стоимость заказа и сформировать (или обновить) чек

CREATE OR REPLACE PROCEDURE update_order(IN ord_num integer, IN idEmp integer = 1)
LANGUAGE 'plpgsql'
AS $$
declare
receiptId integer;
mtotalCost numeric(9,2);
begin

if not exists (select * from customer_order where ordernumber=ord_num ) then
RAISE EXCEPTION 'Не существует данного заказа';
end if;

select receiptnumber into receiptId from customer_order where ordernumber=ord_num;

mtotalCost=ROUND((
select sum(total_cost) as total_cost from(
select sum(top_cost) as total_cost from(
select tl.idproduct,tl.idingredient,  tl.weight,  ing.weight, tl.idingredient, cost, (tl.weight/ing.weight*cost) as top_cost from rowinorder ro
	inner join customer_order ord on ord.ordernumber = ro.ordernumber
	inner join toppinglist tl on (tl.idproduct = ro.idproduct)
	inner join ingredient ing on (tl.idingredient = ing.idingredient)
	where ord.ordernumber = ord_num
	group by tl.idproduct,tl.idingredient,  tl.weight,  ing.weight, tl.idingredient, cost) as toppingx
UNION ALL
select sum(product_sum) as total_cost from(
select pr.idproduct, amount, "name", cost, sum(amount*cost) as product_sum from rowinorder ro
	inner join customer_order ord on ord.ordernumber = ro.ordernumber
	inner join product pr on ro.idproduct = pr.idproduct
	inner join productinpricelist prl on (pr.idproduct = prl.idproduct)
							and (ord.idconfectionary = prl.idconfectionary)
							and (ro.idpricelist = prl.idpricelist)
							where ord.ordernumber = ord_num
							group by pr.idproduct, amount, "name", cost) as orderx
UNION ALL
select -sum(exclusion_sum) as total_cost from(
select rex.idproduct, rex.idingredient, ing."cost", pc.amount, sum(pc.amount * ing."cost") as exclusion_sum  from orderexclusion oe
	inner join customer_order co on oe.ordernumber = co.ordernumber
	inner join rowexclusion rex on oe.idexclusion = rex.idexclusion
	inner join productcomposition pc on pc.idproduct = rex.idproduct and pc.idingredient = rex.idingredient
	inner join ingredient ing on (rex.idingredient = ing.idingredient)
	where co.ordernumber = ord_num
	group by rex.idproduct, rex.idingredient, ing."cost", pc.amount) as  excludex
	) as  totalex)::numeric,2);

if receiptId IS NULL then
	if ((select max(receiptnumber) from receipt) IS NOT NULL) then
		receiptId = (select max(receiptnumber) from receipt) + 1;
	else
		receiptId =0;
	end if;
	insert into receipt (receiptnumber, idemployee, paymentamount)
	values (receiptId, idEmp, mtotalCost);
	update customer_order
	set totalcost = mtotalCost,
	receiptnumber = receiptId
	where ordernumber = ord_num;
else
end if;
	update receipt
	set paymentamount = mtotalCost
	where receiptnumber = receiptId;
	update customer_order
	set totalcost = mtotalCost
	where ordernumber = ord_num;
end;
$$;

2.

Оформление заказа
Вх : номер заказа, информация о продукции, количество, ФИО клиента
Вых: Если номер заказа пустой, то формируется новый заказ и в строке заказа появляется запись
Если сущетсвует, то проверяю принадлежность Клиенту -> вставляются только строки заказа
Если в заказе были включены товары, а клиент хочет изменить заказ, то для существующего заказа -> Обновляет данные

Табличка с продуктами, включаемыми в заказ

CREATE OR REPLACE procedure  addProduct(
									   IN _idproduct integer,
									   IN _amount integer,
									   IN _clientlastname character varying(50),
									   IN _clientfirstname character varying(50),
									   IN _clientsecondname character varying(50),
									   IN _idconfectionary integer,
									   IN _idpricelist integer,
									   IN _ord_num integer = -1)

LANGUAGE 'plpgsql'
AS $BODY$
begin
if _ord_num = -1 then
	_ord_num = (select max(ordernumber) from customer_order) + 1;
 insert into customer_order (ordernumber, idconfectionary, clientlastname, clientfirstname, clientsecondname)
	values(_ord_num, _idconfectionary, _clientlastname, _clientfirstname, _clientsecondname);
 else
 	if not exists (select * from customer_order where
				  (clientlastname = _clientlastname) and (clientfirstname = _clientfirstname) and (clientsecondname = _clientsecondname))
				  then
				  RAISE EXCEPTION 'Другой клиент связан с данным заказом';
				  end if;
 end if;

 insert into rowinorder (ordernumber, idproduct, amount, idpricelist)
	values (_ord_num, _idproduct, _amount, _idpricelist);

 end;
$BODY$;


///////////////////
CREATE OR REPLACE procedure  addProduct2(
									   IN _tbl text,
									   IN _clientlastname character varying(50),
									   IN _clientfirstname character varying(50),
									   IN _clientsecondname character varying(50),
									   IN _idconfectionary integer,
									   IN _ord_num integer = -1)

LANGUAGE 'plpgsql'
AS $BODY$
declare
_cursor refcursor;
_rec  record;
begin
/*raise notice 'New End is "%"', _ord_num;*/
if _ord_num = -1 then
	_ord_num = (select max(ordernumber) from customer_order) + 1;
 insert into customer_order (ordernumber, idconfectionary, clientlastname, clientfirstname, clientsecondname)
	values(_ord_num, _idconfectionary, _clientlastname, _clientfirstname, _clientsecondname);
else
if not exists (select * from customer_order where
				  (clientlastname = _clientlastname) and (clientfirstname = _clientfirstname) and (clientsecondname = _clientsecondname))
				  then
				  RAISE EXCEPTION 'Другой клиент связан с данным заказом или заказа не существует';
				  end if;
 end if;


OPEN _cursor FOR EXECUTE 'SELECT idproduct, amount, idpricelist FROM ' || format('%I', _tbl);
   LOOP
      FETCH NEXT FROM _cursor INTO _rec;
      EXIT WHEN _rec IS NULL;
	  insert into rowinorder (ordernumber, idproduct, amount, idpricelist)
	  	values (_ord_num, _rec.idproduct, _rec.amount, _rec.idpricelist);
   END LOOP;


 end;
$BODY$;