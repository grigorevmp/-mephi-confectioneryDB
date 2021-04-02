import random


class AutoCreateDB:
    def __init__(self):
        self.resultText = ""

        self.clearDB()

        # 1 Confectionary
        self.confIds = range(0, 10)
        self.createConfectionary()
        # 5 Employee
        self.emplID = 0
        self.emplBossID = []
        self.createEmployee()
        # 20 WorkSchedule
        self.schlID = 0
        self.createWorkSchedule()
        # 21 WorkScheduleForEmployee
        self.createWorkScheduleForEmployee()
        # 10 Pricelist
        self.PLINC = [[],[],[],[],[],[],[],[],[],[]]
        self.createPricelist()
        # 11 Pricelist
        self.createPricelistInConfectionary()
        # 2 CookWare
        self.CookWare = []
        self.createCookWare()
        # 18 CookWareInStore
        self.storeID = 0
        self.createStore()
        # 22 CookWareInStore
        self.createCookWareInStore()
        # 6 Ingredient
        self.ingredientID = 0
        self.ingredientCost = {}
        self.createIngredient()
        # 12 Product
        self.productID = 0
        self.createProduct()
        # 7 IngredientInStore
        self.createIngredientInStore()
        # 3 CookwareInProduct
        self.createCookwareInProduct()
        # 13 ProductComposition
        self.productCost = {}
        self.createProductComposition()
        # 14 ProductInPriceList
        self.createProductInPriceList()

    @staticmethod
    def clearDB():
        # 13 ProductComposition
        print("delete from ProductComposition;")
        # 7 IngredientInStore
        print("delete from IngredientInStore;")
        # 3 CookwareInProduct
        print("delete from CookwareInProduct;")
        # 14 ProductInPriceList
        print("delete from ProductInPriceList;")
        # 12 Product
        print("delete from Product;")
        # 6 Ingredient
        print("delete from Ingredient;")
        # 22 CookWareInStore
        print("delete from CookWareInStore;")
        # 18 Store
        print("delete from Store;")
        # 3 CookWare
        #print("delete from CookWareInPriceList;")
        # 2 CookWare
        print("delete from CookWare;")
        # 11 PricelistInConfectionary
        print("delete from PricelistInConfectionary;")
        # 10 Pricelist
        print("delete from Pricelist;")
        # 21 WorkScheduleForEmployee
        print("delete from WorkScheduleForEmployee;")
        # 20 WorkSchedule
        print("delete from WorkSchedule;")
        # 5 Employee
        print("delete from Employee;")
        # 1 Confectionary
        print("delete from Confectionary;")


    def createProductComposition(self):
        conf1 = """INSERT INTO ProductComposition(idProduct, idIngredient, IngredientType, EffectPercent, Amount)
                  VALUES\n"""
        types = ['Основной', 'Заменитель', 'Негативный']
        for i in range(self.productID):
            var = list(range(self.ingredientID))
            sum = 0
            num = random.choice(range(3,6))
            for k in range(num):
                ing = random.choice(var)
                var.remove(ing)
                amount = random.choice(range(1,11))
                conf1 = conf1 + f"({i},{ing},'Основной',{random.choice(range(1,101))},{amount}), \n"
                sum += self.ingredientCost[ing] * amount
            self.productCost[i] = sum
            num = random.choice(range(3,6))
            for k in range(num):
                ing = random.choice(var)
                var.remove(ing)
                conf1 = conf1 + f"({i},{ing},'Заменитель',{random.choice(range(1,101))},{random.choice(range(1,11))}), \n"
                sum += self.ingredientCost[ing]
            num = random.choice(range(3,6))
            for k in range(num):
                ing = random.choice(var)
                var.remove(ing)
                conf1 = conf1 + f"({i},{ing},'Негативный',{random.choice(range(1,101))},{random.choice(range(1,11))}), \n"
                sum += self.ingredientCost[ing]

        conf1 = conf1[:-3] + ";"
        print(conf1)





    def createProduct(self):
        conf1 = """INSERT INTO Product(idProduct, idEmployee, Name, Description, CookingTime, BatchNumber)
                  VALUES\n"""
        idProduct = 0
        with open("products", 'r', encoding='utf-8') as infile:
            for line in infile:
                boss = self.emplBossID[random.choice(range(len(self.emplBossID)))]
                conf1 = conf1 + f"({idProduct},{boss},'{line[:-1]}','none',{random.choice(range(1,400))},{random.choice(range(0,99999))}), \n"
                idProduct += 1
        self.productID = idProduct
        conf1 = conf1[:-3] + ";"
        print(conf1)

    def createIngredient(self):
        conf1 = """INSERT INTO Ingredient(idIngredient, Weight, Cost, Caloricity, WeightInStock, AverageDailyUse, Name,ShelfLife)
                  VALUES\n"""

        idIngredient = 0
        with open("Ingredients", 'r', encoding='utf-8') as infile:
            for line in infile:
                cost = random.choice(range(100,1000))
                self.ingredientCost[idIngredient]=cost
                conf1 = conf1 + f"({idIngredient},{random.choice(range(100,1000))},{cost},{random.choice(range(50,500))},{random.choice(range(1000,100000))},{random.choice(range(1000,10000))},'{line[:-1]}','12.07.2021'), \n"
                idIngredient += 1
        self.ingredientID = idIngredient
        conf1 = conf1[:-3] + ";"
        print(conf1)

    def createStore(self):
        conf1 = """INSERT INTO Store(idStore, Name, Adress)
                  VALUES\n
                    (1,'Охотный Ряд','Манежная пл., 1, стр. 2'),
                    (2,'Рынок Люблино','109559'),
                    (4,'Европейский','пл. Киевского Вокзала, 2'),
                    (3,'ТРЦ Авиапарк','Ходынский б-р, 4'),
                    (5,'ТРЦ «Гагаринский»','ул. Вавилова, 3'),
                    (6,'ТРЦ "Атриум"','ул. Земляной Вал, 33'),
                    (7,'Афимолл Сити','Пресненская наб., 2'),
                    (8,'ТРЦ Ривьера','Автозаводская ул., 18'),
                    (9,'Москва','Кутузовский просп., 31'),
                    (10,'ИКЕА','Калужское ш., 21-й км'),
                    (11,'ИКЕА','Пресненская наб., 2'),
                    (12,'ИКЕА','Ходынский б-р, 4'),
                    (13,'ИКЕА','Лазоревый пр-д, 3 стр 10'),
                    (14,'ИКЕА','7-я Кожуховская ул., 9'),
                    (0,'ИКЕА','1-й Покровский пр-д, 4');"""
        print(conf1)

        self.storeID = 15

    def createCookWare(self):
        conf1 = """INSERT INTO Cookware(Article, idConfectionary, Name, ShortDescription, Amount, Cost)
                  VALUES\n"""

        with open("cookware", 'r', encoding='utf-8') as infile:
            for line in infile:
                names = line.split(".")
                cost = random.choice(range(50, 10000))
                for i in self.confIds:
                    letters = ['A', 'B', 'C']
                    num = f"\'{letters[random.choice(range(3))]}-{random.choice(range(10))}{random.choice(range(10))}{random.choice(range(10))}{random.choice(range(10))}{random.choice(range(10))}\'"
                    if num in self.CookWare:
                        continue
                    else:
                        real = random.choice([1, 2])
                        if real == 1:
                            conf1 = conf1 + f"({num},{i},\'{names[1][1:-1]}\',\'{names[0][:-1]}\',{random.choice(range(1, 1000))},{cost}), \n"
                            self.CookWare.append(num)
        conf1 = conf1[:-3] + ";"
        print(conf1)

    def createProductInPriceList(self):
        conf1 = """INSERT INTO ProductInPriceList(idProduct, idPriceList, idConfectionary, Cost)
                   VALUES\n"""
        for i in range(self.productID):
            for j in range(9):
                for k in range(len(self.PLINC[j])):
                    isR = random.choice([1, 2])
                    if isR == 1:
                        conf1 = conf1 + f"({i},{self.PLINC[j][k]},{j}, {self.productCost[i]}), \n"

        conf1 = conf1[:-3] + ";"
        print(conf1)


    def createCookwareInProduct(self):
        conf1 = """INSERT INTO CookwareInProduct(idProduct, Article, Amount)
                   VALUES\n"""
        for i in range(self.productID):
            for j in range(len(self.CookWare)):
                isR = random.choice([1, 2])
                if isR == 1:
                    conf1 = conf1 + f"({i},{self.CookWare[j]},{random.choice(range(1, 100))}), \n"

        conf1 = conf1[:-3] + ";"
        print(conf1)

    def createIngredientInStore(self):
        conf1 = """INSERT INTO IngredientInStore(idStore, idIngredient, Cost, Availability)
                   VALUES\n"""

        for i in range(self.storeID):
            for j in range(self.ingredientID):
                cost = random.choice(range(50, 10000))
                availability = random.choice(range(0, 1000))
                isR = random.choice([1, 2])
                if isR == 1:
                    conf1 = conf1 + f"({i},{j},{cost},{availability}), \n"

        conf1 = conf1[:-3] + ";"
        print(conf1)


    def createCookWareInStore(self):
        conf1 = """INSERT INTO CookwareInStore(idStore, Artice, Cost, Availability)
                   VALUES\n"""

        for i in range(self.storeID):
            for j in range(len(self.CookWare)):
                cost = random.choice(range(50, 10000))
                availability = random.choice(range(0, 1000))
                isR = random.choice([1, 2])
                if isR == 1:
                    conf1 = conf1 + f"({i},{self.CookWare[j]},{cost},{availability}), \n"

        conf1 = conf1[:-3] + ";"
        print(conf1)

    def createPricelistInConfectionary(self):
        conf1 = """INSERT INTO PricelistInConfectionary(idConfectionary, idPricelist, ValideTime)
                  VALUES\n"""

        for i in self.confIds:
            result = [random.choice([1, 2]), random.choice([1, 2]), random.choice([1, 2]), random.choice([1, 2]),
                      random.choice([1, 2]), random.choice([1, 2]), random.choice([1, 2]), random.choice([1, 2]),
                      random.choice([1, 2])]

            conf1 = conf1 + f"({i},{0}, \'31.12.2021\'), \n"
            self.PLINC[i] = [0]
            if result[1] == 1:
                conf1 = conf1 + f"({i},{1}, \'10.05.2021\'), \n"
                self.PLINC[i].append(1)
            if result[2] == 1:
                conf1 = conf1 + f"({i},{2}, \'10.05.2021\'), \n"
                self.PLINC[i].append(2)
            if result[3] == 1:
                conf1 = conf1 + f"({i},{3}, \'31.01.2021\'), \n"
                self.PLINC[i].append(3)
            if result[4] == 1:
                conf1 = conf1 + f"({i},{4}, \'31.08.2021\'), \n"
                self.PLINC[i].append(4)
            if result[5] == 1:
                conf1 = conf1 + f"({i},{5}, \'28.02.2021\'), \n"
                self.PLINC[i].append(5)
            if result[6] == 1:
                conf1 = conf1 + f"({i},{6}, \'30.11.2021\'), \n"
                self.PLINC[i].append(6)
            if result[7] == 1:
                conf1 = conf1 + f"({i},{7}, \'31.05.2021\'), \n"
                self.PLINC[i].append(7)
            if result[8] == 1:
                conf1 = conf1 + f"({i},{8}, \'31.12.2021\'), \n"
                self.PLINC[i].append(8)

        conf1 = conf1[:-3] + ";"
        print(conf1)

    def createPricelist(self):
        conf1 = """INSERT INTO Pricelist(idPricelist,Name)
                  VALUES\n"""
        conf1 = conf1 + "(0, \'Основной     \'),\n"
        conf1 = conf1 + "(1, \'Пасхальный   \'),\n"
        conf1 = conf1 + "(2, \'Постный      \'),\n"
        conf1 = conf1 + "(3, \'Новогодний   \'),\n"
        conf1 = conf1 + "(4, \'Летний       \'),\n"
        conf1 = conf1 + "(5, \'Зимний       \'),\n"
        conf1 = conf1 + "(6, \'Осенний      \'),\n"
        conf1 = conf1 + "(7, \'Весенний     \'),\n"
        conf1 = conf1 + "(8, \'Праздничный  \');"
        print(conf1)

    def createWorkSchedule(self):
        # 20 WorkSchedule
        days = ['\'Понедельник\'', '\'Вторник\'', '\'Среда\'', '\'Четверг\'',
                '\'Пятница\'', '\'Суббота\'', '\'Воскресенье\'']
        conf1 = """INSERT INTO WorkSchedule(idSchedule, WorkingDay, StartWorkTime, EndWorkTime, StartDinnerTime, 
                EndDinerTime)
                            VALUES\n"""

        idSchedule = 0

        for i in range(7):
            for j in range(6):
                startTimef = random.choice(range(5, 18))
                if startTimef < 10:
                    startTimefZ = f"0{startTimef}"
                else:
                    startTimefZ = f"{startTimef}"
                startTimeM = random.choice(range(0, 59))
                if startTimeM < 10:
                    startTimeMZ = f"0{startTimeM}"
                else:
                    startTimeMZ = f"{startTimeM}"
                startTime = f"\'{startTimefZ}:{startTimeMZ}\'"

                endTimef = random.choice(range(startTimef + 2, 24))
                if endTimef < 10:
                    endTimefZ = f"0{endTimef}"
                else:
                    endTimefZ = f"{endTimef}"
                endTimefM = random.choice(range(0, 59))
                if endTimefM < 10:
                    endTimefMZ = f"0{endTimefM}"
                else:
                    endTimefMZ = f"{endTimefM}"

                endTime = f"\'{endTimefZ}:{endTimefMZ}\'"

                StartDinnerTime = f"\'{(startTimef + endTimef) // 2}:00\'"
                EndDinerType = random.choice([1, 2])
                if EndDinerType == 1:
                    EndDinerTime = f"\'{(startTimef + endTimef) // 2 + 1}:00\'"
                else:
                    EndDinerTime = f"\'{(startTimef + endTimef) // 2}:30\'"

                string = f" ({idSchedule}, {days[i]}, {startTime}, {endTime}, {StartDinnerTime}, {EndDinerTime}), \n"
                conf1 = conf1 + string
                idSchedule += 1

        self.schlID = idSchedule
        conf1 = conf1[:-3] + ";"

        print(conf1)

    def createWorkScheduleForEmployee(self):
        conf1 = """INSERT INTO WorkScheduleForEmployee(idSchedule, idEmployee)
                VALUES """

        for i in range(self.emplID):
            smena = random.choice([0, 1])
            if smena == 0:
                string = f"({random.choice(range(0, 6))},{i}), \n"
                conf1 = conf1 + string
                string = f"({random.choice(range(6, 12))},{i}), \n"
                conf1 = conf1 + string
            string = f"({random.choice(range(12, 18))},{i}), \n"
            conf1 = conf1 + string
            string = f"({random.choice(range(18, 24))},{i}), \n"
            conf1 = conf1 + string
            string = f"({random.choice(range(24, 30))},{i}), \n"
            conf1 = conf1 + string
            if smena == 1:
                string = f"({random.choice(range(30, 36))},{i}), \n"
                conf1 = conf1 + string
                string = f"({random.choice(range(36, 42))},{i}), \n"
                conf1 = conf1 + string

        conf1 = conf1[:-3] + ";"
        print(conf1)
        pass

    def createEmployee(self):
        # 5 Employee
        # idEmployee, idConfectionary, Passport, Emp_Position, BaseRate,
        # MinWorkingHours, Salary, LastName, FirstName, SecondName

        positions = [1, 1, random.choice([2, 3]), random.choice([2, 3]), random.choice([7, 10])]

        conf1 = """INSERT INTO Employee(idEmployee, idConfectionary, Passport, Emp_Position, BaseRate, 
                MinWorkingHours, Salary, LastName, FirstName, SecondName)
                            VALUES"""
        currentNum = 0
        currentSubNum = 0
        idEmployee = 0
        idConfectionary = self.confIds[0]
        break_all = False
        with open("names", 'r', encoding='utf-8') as infile:
            for line in infile:
                names = line.split(" ")
                my_range = range(0, 10)
                Emp_Positions = ["\'Владелец\'", "\'Шеф-Кондитер\'", "\'Курьер\'", "\'Кассир\'", "\'Кондитер\'"]
                passport = f"{random.choice(my_range)}{random.choice(my_range)}{random.choice(my_range)}{random.choice(my_range)} {random.choice(my_range)}{random.choice(my_range)}{random.choice(my_range)}{random.choice(my_range)}{random.choice(my_range)}{random.choice(my_range)}"
                BaseRate = random.choice(range(10000, 100000))
                MinWorkingHours = random.choice(range(30, 40))
                Salary = random.choice(range(10000, 100000))
                if currentNum == 1:
                    self.emplBossID.append(idEmployee)
                string = f" ({idEmployee},{idConfectionary},'{passport}',{Emp_Positions[currentNum]},{BaseRate},{MinWorkingHours},{Salary},\'{names[0]}\',\'{names[1]}\', \'{names[2][:-1]}\'), \n"

                idEmployee += 1
                conf1 = conf1 + string
                currentSubNum += 1
                if currentSubNum == positions[currentNum]:
                    currentSubNum = 0
                    currentNum += 1
                if currentNum == 5:
                    currentNum = 0
                    idConfectionary += 1
                    positions = [1, 1, random.choice([2, 3]), random.choice([2, 3]), random.choice([7, 10])]
                if idConfectionary == 10:
                    break_all = True

                if break_all:
                    break
        self.emplID = idEmployee
        conf1 = conf1[:-3] + ";"

        print(conf1)

    @staticmethod
    def createConfectionary():
        # 1 Confectionary
        # idConfectionary, Address, WorkingTime, RentCost

        conf1 = """INSERT INTO Confectionary(idConfectionary, Address, WorkingTime, RentCost)
                    VALUES (0, 'ул. Москворечье д2к2', 'Пн-Пт 7:30-23:00 Без обеда', 50000),
                            (1, 'Каширское шоссе, 31', 'Пн-Пт 8:30-23:00 Без обеда', 100000),
                            (2, 'ул. Большая Ордынка, 24', 'Пн-Пт 9:00-22:00 Обед 13:00-14:00', 200000),
                            (4, 'Раменки, Ленинские Горы, 1', 'Пн-Пт 8:30-23:00 Без обеда', 100000),
                            (3, 'Ленинградское шоссе, 16Ас3', 'Пн-Пт 9:30-23:00 Без обеда', 150000),
                            (5, 'Красная площадь, 3', 'Пн-Пт 8:30-23:00 Без обеда', 400000),
                            (6, 'Ходынский бульвар, 4', 'Пн-Пт 7:00-22:00 Без обеда', 174500),
                            (7, 'Каширское шоссе, 61Г', 'Пн-Пт 8:30-23:00 Без обеда', 150000),
                            (8, 'Проспект Мира, 211к2', 'Пн-Пт 8:30-23:00 Обед 13:00-13:30', 145000),
                            (9, 'Пресненская набережная, 2', 'Пн-Пт 8:30-23:00 Без обеда', 400000);"""
        print(conf1)


if __name__ == "__main__":
    db = AutoCreateDB()
