# 1) Состояние дел кондитерской
#	- Данные
#	- Количество заказов
#	- Доход
#	- Сумм кол-во ингрединтов
# 	- Кол-во клиентов

select conf.idconfectionary as
	Номер, address as Адрес,
	workingtime as График,
	rentcost as Аренда,
	Orders_num as Заказы,
	Orders_cost as Доход,
	Unique_clients as Клиенты,
	Unique_idingredient as Ингредиенты
from confectionary conf
left join
(select idconfectionary, count(*) as Orders_num, sum(totalcost) as Orders_cost from customer_order co group by idconfectionary) as orders
on orders.idconfectionary = conf.idconfectionary
left join
(select idconfectionary, count(*) as Unique_clients from
	(select idconfectionary, clientfirstname, clientlastname, clientsecondname from customer_order
		group by idconfectionary, clientfirstname, clientlastname, clientsecondname)
	as unique_clients group by idconfectionary) as clients
on clients.idconfectionary = conf.idconfectionary
left join
(select idconfectionary, count(*) as Unique_idingredient from
(select distinct ppl.idconfectionary, pc.idingredient from productinpricelist ppl
join productcomposition  pc
on ppl.idproduct = pc.idproduct)
 as unique_ing group by idconfectionary) as ings
on ings.idconfectionary = conf.idconfectionary;


# 2) Ингредиенты, которые используются чаще всего
#	- Название
#	- Суммарное количество
#	- Количество топпингов
#	- Количество заказов

select idingredient, COALESCE(using_num, 0) as КоличествоИспользований, COALESCE(ord_num, 0) as КоличествоЗаказов, COALESCE(liketopping, 0) as ЗаказТоппинга from
(
select * from ingredient
left join
(select ing, count(prod) as using_num from
(select pc.idingredient as ing, pc.idproduct as prod
from customer_order co
join rowinorder ro ON ro.ordernumber = co.ordernumber
JOIN productcomposition pc on pc.idproduct = ro.idproduct) as tt3
group by ing) as tt30
on idingredient = tt30.ing
left join
(select ing, count(ord) as ord_num from
(select distinct pc.idingredient as ing, co.ordernumber as ord
from customer_order co
join rowinorder ro ON ro.ordernumber = co.ordernumber
JOIN productcomposition pc on pc.idproduct = ro.idproduct) as tt
group by ing) as tt0
on idingredient = tt0.ing
left join
(select ing, count(idproduct) as liketopping from
(select idingredient as ing, idproduct from toppinglist) as tt2
group by ing) as tt20
on idingredient = tt20.ing
) as tt
order by КоличествоИспользований DESC

# 3) Информация о работнике - Кассир, курьер
#	- Данные
#	- Количество
#	- Количество накладных и чеков
#	- Количесвто заказов
#	- Стоимость заказов

select
	em.idemployee as Номер,
	idconfectionary as Кондитерская,
	passport as Паспорт,
	emp_position as Должность,
	baserate as Ставка,
	minworkinghours as Часы,
	salary as Зарплата,
	lastname as Фамилия,
	firstname as Имя,
	secondname as Отчество,
	cost_sum as Выручка,
	Payment_num as ЧекиИНакладные,
	Order_num as Заказы,
	array_agg(ws.workingday) as Смены
from employee em
join workscheduleforemployee wse
on wse.idemployee = em.idemployee
join workschedule ws
on ws.idschedule = wse.idschedule
left join
(select idemployee, cost_sum, Payment_num, Order_num from(
select idemployee, sum(paymentamount) as cost_sum, count(paymentamount) as Payment_num , count(co.ordernumber) as Order_num
from receipt
join customer_order co
on co.receiptnumber = receipt.receiptnumber
group by idemployee
UNION ALL
select idemployee, sum(totalcost) as cost_sum, count(totalcost) as Payment_num , count(co.ordernumber) as Order_num
from invoice
join customer_order co
on co.invoicenumber = invoice.invoicenumber
group by idemployee) as ff) as tt
on em.idemployee = tt.idemployee
where emp_position = 'Курьер' or emp_position = 'Кассир'
group by em.idemployee, cost_sum, Payment_num, Order_num;

# 4) Информация о работнике - Шеф-кондитер
#	- Данные
#	- Количество созданных рецептов
#	- Количесвто заказов
#	- Стоимость заказов

select
	em.idemployee as Номер,
	idconfectionary as Кондитерская,
	passport as Паспорт,
	emp_position as Должность,
	baserate as Ставка,
	minworkinghours as Часы,
	salary as Зарплата,
	lastname as Фамилия,
	firstname as Имя,
	secondname as Отчество,
	products as Рецепты,
	array_agg(ws.workingday) as Смены,
	total_cost as ПринесённыйДоход,
	orders as ЧислоЗаказов
from employee em
join workscheduleforemployee wse
on wse.idemployee = em.idemployee
join workschedule ws
on ws.idschedule = wse.idschedule
left join (
select emp, count(ord) as orders, sum(total_cost) as total_cost from(
select emp, ord, sum(amount*cost_) as total_cost from
(select distinct "cost" as cost_, pr.idproduct as prod, amount, pr.idemployee as emp, co.ordernumber as ord from product pr
join rowinorder ro
on ro.idproduct = pr.idproduct
join customer_order co
on co.ordernumber = ro.ordernumber
join productinpricelist
ON productinpricelist.idproduct = pr.idproduct) as pr_data
group by emp, ord) as pr_data2
group by emp) as t2
on em.idemployee = t2.emp
left join
(select emp, count(prod) as products from(
select pr.idproduct as prod, pr.idemployee as emp from product pr) as pr_data
group by emp) as t1
on em.idemployee = t1.emp
where emp_position = 'Шеф-Кондитер'
group by em.idemployee, products, total_cost, orders;

# 5) Ингредиент
#	- Количество продуктов, где он положительно влияет
#	- Где отрицательно влияет
#	- Где может быть заменителем
#	- Суммарное количество продуктов

select
	ing.idingredient as Номер,
	ing."name" as Название,
	Negative as Отрицательный,
	round(AE_Negative, 2) as СреднееОтрицательноеВлияние,
	Positive as Положительный,
	round(AE_Positive, 2) as СреднееПоложительноеВлияние,
	Alternative as Альтернативный,
	round(AE_Alternative, 2) as СреднееАльтернативноеВлияние
	from ingredient ing
left join
(select idingredient, count(ingredienttype) as Negative, avg(effectpercent) as AE_Negative from productcomposition
	where ingredienttype = 'Негативный'
	group by idingredient) as tt
on ing.idingredient = tt.idingredient
left join
(select idingredient, count(ingredienttype) as Positive, avg(effectpercent) as AE_Positive from productcomposition
	where ingredienttype = 'Основной'
	group by idingredient) as tt1
on ing.idingredient = tt1.idingredient
left join
(select idingredient, count(ingredienttype) as Alternative, avg(effectpercent) as AE_Alternative from productcomposition
	where ingredienttype = 'Заменитель'
	group by idingredient) as tt2
on ing.idingredient = tt2.idingredient
