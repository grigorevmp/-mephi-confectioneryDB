DROP TABLE IF EXISTS Confectionary CASCADE;
CREATE TABLE Confectionary
(
    idConfectionary integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Address character varying(50) NOT NULL UNIQUE,
    WorkingTime character varying(50) NOT NULL,
    RentCost decimal(7,2) NOT NULL CHECK (RentCost > 0.0)
);

DROP TABLE IF EXISTS WorkSchedule CASCADE;
CREATE TABLE WorkSchedule
(
    idSchedule integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    WorkingDay character varying(15) NOT NULL CHECK(WorkingDay in ('Понедельник', 'Вторник', 'Среда',
																   'Четверг', 'Пятница', 'Суббота', 'Воскресенье')),
    StartWorkTime time without time zone NOT NULL,
    EndWorkTime time without time zone NOT NULL CHECK (EndWorkTime > StartWorkTime),
    StartDinnerTime time without time zone CHECK (StartDinnerTime between StartWorkTime and EndWorkTime),
    EndDinerTime time without time zone CHECK (EndDinerTime between StartDinnerTime and EndWorkTime)
);


DROP TABLE IF EXISTS Employee CASCADE;
CREATE TABLE Employee
(
    idEmployee integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    idConfectionary integer NOT NULL,
    Passport character varying(40) NOT NULL UNIQUE,
    Position character varying(30) NOT NULL CHECK (Position IN ('Шеф-Кондитер',
    	'Кондитер', 'Кассир', 'Курьер', 'Владелец')),
    BaseRate decimal(6,2) NOT NULL CHECK (BaseRate > 0.00),
    MinWorkingHours integer NOT NULL CHECK (MinWorkingHours > 0),
    Salary decimal(6,2) NOT NULL CHECK (Salary > 0.00),
    LastName character varying(30) NOT NULL,
    FirstName character varying(30) NOT NULL,
    SecondName character varying(30),
    FOREIGN KEY (idConfectionary)
        REFERENCES Confectionary (idConfectionary) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);


DROP TABLE IF EXISTS WorkScheduleForEmployee CASCADE;
CREATE TABLE WorkScheduleForEmployee
(
    idSchedule integer NOT NULL,
    idEmployee integer NOT NULL,
	PRIMARY KEY (idSchedule, idEmployee),
        FOREIGN KEY (idSchedule)
        REFERENCES WorkSchedule (idSchedule) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idEmployee)
        REFERENCES Employee (idEmployee) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Cookware CASCADE;
CREATE TABLE Cookware
(
    Article character varying(30) NOT NULL PRIMARY KEY ,
    idConfectionary integer NOT NULL,
    Name character varying(30) NOT NULL UNIQUE,
    ShortDescription character varying(100),
    Amount integer NOT NULL CHECK (Amount >= 0),
    Cost decimal(6, 2) NOT NULL CHECK (Cost > 0.00),
    FOREIGN KEY (idConfectionary)
        REFERENCES Confectionary (idConfectionary) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Ingredient CASCADE;
CREATE TABLE Ingredient
(
    idIngredient integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Weight decimal(7, 2) NOT NULL CHECK (Weight >= 0.00),
    Cost decimal(6, 2) NOT NULL CHECK (Cost > 0.00),
    Caloricity integer NOT NULL CHECK (Caloricity >= 0.00),
    WeightInStock decimal(7, 2) NOT NULL CHECK (WeightInStock >= 0.00),
    AverageDailyUse decimal(7, 2) NOT NULL CHECK (AverageDailyUse >= 0.00),
    Name character varying(30) NOT NULL UNIQUE,
    ShelfLife timestamp without time zone NOT NULL
);

DROP TABLE IF EXISTS Store CASCADE;
CREATE TABLE Store
(
    idStore integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Name character varying(30) NOT NULL,
    Adress character varying(40) NOT NULL,
    UNIQUE (Name, Adress)
);

DROP TABLE IF EXISTS IngredientInStore CASCADE;
CREATE TABLE IngredientInStore
(
    idStore integer NOT NULL,
    idIngredient integer NOT NULL,
    Cost decimal(6, 2) NOT NULL CHECK (Cost > 0.00),
    Availability decimal(7, 2) NOT NULL CHECK (Availability >= 0.00),
    PRIMARY KEY (idStore, idIngredient),
    FOREIGN KEY (idIngredient)
        REFERENCES Ingredient (idIngredient) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idStore)
        REFERENCES Store (idStore) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS CookwareInStore CASCADE;
CREATE TABLE CookwareInStore
(
    idStore integer NOT NULL,
    Artice character varying(30) NOT NULL,
    Cost decimal(6, 2) NOT NULL CHECK (Cost > 0.00),
    Availability integer NOT NULL CHECK (Availability >= 0),
    PRIMARY KEY (idStore, Artice),
    FOREIGN KEY (Artice)
        REFERENCES Cookware (Article) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idStore)
        REFERENCES Store (idStore) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Pricelist CASCADE;
CREATE TABLE Pricelist
(
    idPricelist integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Name character varying(30) NOT NULL
);

DROP TABLE IF EXISTS PricelistInConfectionary CASCADE;
CREATE TABLE PricelistInConfectionary
(
    idConfectionary integer NOT NULL,
    idPriceList integer NOT NULL,
    ValideTime timestamp without time zone NOT NULL,
    PRIMARY KEY (idConfectionary, idPriceList),
    FOREIGN KEY (idConfectionary)
        REFERENCES Confectionary (idConfectionary) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idPriceList)
        REFERENCES Pricelist (idPricelist) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Receipt CASCADE;
CREATE TABLE Receipt
(
    ReceiptNumber integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    idEmployee integer NOT NULL,
    PaymentType character varying(20),
    PaymentFormat character varying(20),
    PaymentSuccessfulMark boolean,
    PaymentAmount decimal(7, 2) NOT NULL CHECK (PaymentAmount >= 0.00),
    FOREIGN KEY (idEmployee)
        REFERENCES Employee (idEmployee) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Invoice CASCADE;
CREATE TABLE Invoice
(
    InvoiceNumber integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    idEmployee integer NOT NULL,
    DeliveryAddress character varying(50) NOT NULL,
    ClaimText character varying(256),
    ReturnMark boolean,
    Signature boolean,
    FOREIGN KEY (idEmployee)
        REFERENCES Employee (idEmployee) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Customer_Order CASCADE;
CREATE TABLE Customer_Order
(
    OrderNumber integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    InvoiceNumber integer,
    ReceiptNumber integer,
    idConfectionary integer NOT NULL,
    TotalCost decimal(7, 2) NOT NULL CHECK (TotalCost >= 0.00), 
    ClientLastName character varying(30) NOT NULL,
    ClientFirstName character varying(30) NOT NULL,
    ClientSecondName character varying(30),
    Date timestamp without time zone NOT NULL,
    FOREIGN KEY (idConfectionary)
        REFERENCES Confectionary (idConfectionary) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (InvoiceNumber)
        REFERENCES Invoice (InvoiceNumber) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (ReceiptNumber)
        REFERENCES Receipt (ReceiptNumber) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);


DROP TABLE IF EXISTS Product CASCADE;
CREATE TABLE Product
(
    idProduct integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    idEmployee integer,
    Name character varying(30) NOT NULL,
    Description character varying(256),
    CookingTime character varying(30) NOT NULL,
    BatchNumber character varying(30) NOT NULL,
    FOREIGN KEY (idEmployee)
        REFERENCES Employee (idEmployee) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

DROP TABLE IF EXISTS ProductInPriceList CASCADE;
CREATE TABLE ProductInPriceList
(
    idProduct integer NOT NULL,
    idPriceList integer NOT NULL,
    idConfectionary integer NOT NULL,
    Cost decimal(6, 2) NOT NULL CHECK (Cost >= 0.00),
    PRIMARY KEY (idConfectionary, idPriceList, idProduct),
    FOREIGN KEY (idConfectionary, idPriceList)
        REFERENCES PricelistInConfectionary (idConfectionary, idPriceList) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idProduct)
        REFERENCES Product (idProduct) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS CookwareInProduct CASCADE;
CREATE TABLE CookwareInProduct
(
    idProduct integer NOT NULL,
    Article character varying(30) NOT NULL,
    Amount integer NOT NULL CHECK (Amount > 0),
    PRIMARY KEY (idProduct, Article),
    FOREIGN KEY (Article)
        REFERENCES Cookware (Article) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idProduct)
        REFERENCES Product (idProduct) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);


DROP TABLE IF EXISTS ProductComposition CASCADE;
CREATE TABLE ProductComposition
(
    idProduct integer NOT NULL,
    idIngredient integer NOT NULL,
    IngredientType character varying(20) NOT NULL CHECK(IngredientType in ('Основной', 'Заменитель', 'Негативный')),
    EffectPercent decimal(3, 2) NOT NULL CHECK (EffectPercent BETWEEN 0.00 AND 100.00),
    Amount decimal(6, 2) NOT NULL CHECK (Amount > 0.00),
    PRIMARY KEY (idProduct, idIngredient),
    FOREIGN KEY (idIngredient)
        REFERENCES Ingredient (idIngredient) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idProduct)
        REFERENCES Product (idProduct) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS OrderExclusion CASCADE;
CREATE TABLE OrderExclusion
(
    idExclusion integer NOT NULL GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    OrderNumber integer NOT NULL,
    FOREIGN KEY (OrderNumber)
        REFERENCES Customer_Order (OrderNumber) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS RowInOrder CASCADE;
CREATE TABLE RowInOrder
(
    OrderNumber integer NOT NULL,
    idProduct integer NOT NULL,
    Amount integer NOT NULL,
    PRIMARY KEY (OrderNumber, idProduct),
    FOREIGN KEY (OrderNumber)
        REFERENCES Customer_Order (OrderNumber) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idProduct)
        REFERENCES Product (idProduct) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS ToppingList CASCADE;
CREATE TABLE ToppingList
(
    idIngredient integer NOT NULL,
    OrderNumber integer NOT NULL,
    idProduct integer NOT NULL,
    Weight decimal(7, 2) NOT NULL CHECK (Weight >= 0.00),
    PRIMARY KEY (idProduct, OrderNumber, idIngredient),
    FOREIGN KEY (idIngredient)
        REFERENCES Ingredient (idIngredient) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (OrderNumber, idProduct)
        REFERENCES RowInOrder (OrderNumber, idProduct) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

DROP TABLE IF EXISTS RowExclusion CASCADE;
CREATE TABLE RowExclusion
(
    idProduct integer NOT NULL,
    idExclusion integer NOT NULL,
    idIngredient integer NOT NULL,
    PRIMARY KEY (idProduct, idExclusion),
    FOREIGN KEY (idExclusion)
        REFERENCES OrderExclusion (idExclusion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idIngredient)
        REFERENCES Ingredient (idIngredient) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    FOREIGN KEY (idProduct)
        REFERENCES Product (idProduct) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);



