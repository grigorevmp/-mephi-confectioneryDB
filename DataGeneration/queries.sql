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
