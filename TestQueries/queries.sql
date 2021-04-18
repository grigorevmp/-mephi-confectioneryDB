delete from ToppingList;
delete from RowInOrder;
delete from Product;
delete from Customer_Order;
delete from Invoice;
delete from WorkSchedule;
delete from Employee;
delete from WorkScheduleForEmployee;
delete from Confectionary;

INSERT INTO Confectionary(idConfectionary, Address, WorkingTime, RentCost)
VALUES (0, 'ул. Москворечье д2к2', 'Пн-Пт 8:30-23:00 Без обеда', 5);

INSERT INTO Ingredient(idIngredient, Weight, Cost,
					 	Caloricity, WeightInStock, AverageDailyUse, Name, ShelfLife)
VALUES  (0, 150.00, 100, 
	20, 10000.00, 80.00, 'Тесто', '12.11.2021'),
		(1, 80.00, 140, 
	80, 10000.00, 40.00, 'Шоколад', '13.11.2021'),		
		(2, 50.00, 190, 
	50, 10000.00, 10.00, 'Малиновое варенье', '14.11.2021');

INSERT INTO WorkSchedule(idSchedule, WorkingDay, StartWorkTime,
					 EndWorkTime, StartDinnerTime, EndDinerTime)
VALUES (0, 'Понедельник', '10:00', '20:00', '12:00', '13:00'),
		(1, 'Вторник', '10:00', '20:00', '12:00', '13:00'),
		(2, 'Вторник', '06:00', '09:00', '08:00', '08:10'),
		(3, 'Вторник', '15:00', '18:00', '17:00', '17:30'),
		(4, 'Вторник', '15:00', '22:00', '17:00', '17:30'),
		(5, 'Вторник', '08:00', '15:00', '12:00', '13:00'),
		(6, 'Среда', '07:00', '18:00', '12:00', '13:00');
		 
INSERT INTO Employee(idEmployee, idConfectionary,
					 Passport, Position, BaseRate,
					  MinWorkingHours, Salary, LastName, FirstName, SecondName)
VALUES (0, 0, '0000 000000', 'Кондитер', 200,  20,  200, 'Иванов', 'Иван', 'Иванович'),
		(22, 0, '0000 000022', 'Шеф-Кондитер', 2000,  40,  2000, 'Максимов', 'Максим', 'Максимович'),
		(1, 0, '0000 000001', 'Кондитер', 200,  20,  200, 'Петров', 'Петр', 'Петрович');

INSERT INTO WorkScheduleForEmployee(idSchedule, idEmployee)
	VALUES 
	(0, 0),
	 (0, 1), 
	 (1, 0);


INSERT INTO Product(idProduct, idEmployee, Name,
					 CookingTime, BatchNumber)
VALUES (0, 22, 'Пирожок с шоколадом', 20, 12);


INSERT INTO Customer_Order(OrderNumber, 
					idConfectionary, TotalCost, ClientLastName,
				   ClientFirstName, ClientSecondName, Date)
VALUES (0, 0, 100, 'Андреев', 'Андрей', 'Андреевич', '20.03.201');


INSERT INTO RowInOrder(OrderNumber, idProduct, Amount)
VALUES (0, 0, 2);

//

delete from ToppingList;

INSERT INTO ToppingList(idIngredient, OrderNumber, idProduct, Weight)
VALUES (2, 0, 0, 400.00);

/*INSERT INTO WorkScheduleForEmployee(idSchedule, idEmployee)
	VALUES (2, 0);
	
DELETE from WorkScheduleForEmployee where idSchedule = 2 and idEmployee = 0;*/



//////////////////////

SELECT * from WorkSchedule ws
JOIN
WorkScheduleForEmployee wsfe
ON ws.idSchedule = wsfe.idSchedule
ORDER BY wsfe.idemployee;
/*select * from customer_order;
select * from Ingredient;*/




//////////////////////

//////////////////////

//////////////////////

//////////////////////

//////////////////////


select sum(product_sum) as final_cost_order from(
select pr.idproduct, amount, "name", cost, sum(amount*cost) as product_sum from rowinorder ro
	inner join customer_order ord on ord.ordernumber = ro.ordernumber
	inner join product pr on ro.idproduct = pr.idproduct
	inner join productinpricelist prl on (pr.idproduct = prl.idproduct)
							and (ord.idconfectionary = prl.idconfectionary)
							and (ro.idpricelist = prl.idpricelist)
							where ord.ordernumber = 13
							group by pr.idproduct, amount, "name", cost) as orderx;


select sum(top_cost) as final_top_cost from(
select tl.idproduct,tl.idingredient,  tl.weight,  ing.weight, tl.idingredient, cost, (tl.weight/ing.weight*cost) as top_cost from rowinorder ro
	inner join customer_order ord on ord.ordernumber = ro.ordernumber
	inner join toppinglist tl on (tl.idproduct = ro.idproduct)
	inner join ingredient ing on (tl.idingredient = ing.idingredient)
	where ord.ordernumber = 13
	group by tl.idproduct,tl.idingredient,  tl.weight,  ing.weight, tl.idingredient, cost) as toppingx;


select rex.idproduct, rex.idingredient, ing."cost", pc.amount from orderexclusion oe
	inner join customer_order co on oe.ordernumber = co.ordernumber
	inner join rowexclusion rex on oe.idexclusion = rex.idexclusion
	inner join productcomposition pc on pc.idproduct = rex.idproduct
	inner join ingredient ing on (rex.idingredient = ing.idingredient);



/*delete from rowexclusion;
delete from orderexclusion;
delete from toppinglist;
delete from rowinorder;
delete from customer_order;

insert into customer_order (ordernumber, idconfectionary, clientlastname, clientfirstname, clientsecondname)
	values(13, 2, 'Иванов', 'Иван', 'Иванович');

insert into rowinorder (ordernumber, idproduct, amount, idpricelist)
	values (13, 1, 1, 2), (13, 4, 2, 0), (13, 8, 1, 0), (13, 52, 1, 0),
			(13, 35, 1, 2), (13, 38, 1, 2), (13, 58, 5, 3), (13, 60, 2, 0);

insert into toppinglist (idingredient, ordernumber, idproduct, weight)
	values (5, 13, 1, 120.00), (35, 13, 4, 40.00), (45, 13, 58, 30.00), (55, 13, 60, 110.00);

insert into orderexclusion(idexclusion, ordernumber)
	values(12, 13);

insert into rowexclusion(idproduct, idexclusion, idingredient)
	values(1, 12, 4), (1, 12, 8);*/
/* ----------- 2 ---------------*/
/*CALL update_order(13);

select * from customer_order;*/
/* ----------- 3 ---------------*/
/*insert into toppinglist (idingredient, ordernumber, idproduct, weight)
	values (0, 13, 1, 762.00);*/
/* ----------- 4 ---------------*/
/* CALL update_order(13);

select * from customer_order;*/



/* ----------- 4 ---------------*/

delete from productList;
drop table if exists productList;
drop type if exists products;

CREATE TYPE products AS (idproduct integer, amount integer, idpricelist integer);

CREATE TABLE public.productList OF products (PRIMARY KEY(idproduct));

INSERT INTO productList VALUES
    (0, 0, 1),
    (2, 3, 1),
    (6, 3, 1),
    (10, 3, 1),
    (37, 3, 1);


/*delete from rowinorder where ordernumber = 14;
delete from customer_order where ordernumber = 14;*/

/*call addProduct2('productlist', 'Григорьев', 'Михаил', 'Павлович', 2, 13);*/
/*call addProduct2('productlist', 'Григорьев', 'Михаил', 'Павлович', 2);*/

/*select * from customer_order;
select * from rowinorder;*/


/*--------------*/
/*delete from rowinorder where ordernumber = 13 and idproduct=0;*/
/*delete from productList;
drop table if exists productList;
drop type if exists products;

CREATE TYPE products AS (idproduct integer, amount integer, idpricelist integer);

CREATE TABLE public.productList OF products (PRIMARY KEY(idproduct));

INSERT INTO productList VALUES
    (0, 6, 2);

call addProduct2('productlist', 'Иванов', 'Иван', 'Иванович', 2, 13);
select * from rowinorder;*/