Триггеры:

/*1. Когда оформляется заказ на продукцию и включается запись о новом топпинге,
проверяется есть ли данный топпинг на складе и уменьшается его количество на складе*/

DROP TRIGGER if exists new_topping on ToppingList CASCADE;
DROP FUNCTION if exists trigger_ToppingList_before CASCADE;
CREATE FUNCTION trigger_ToppingList_before() RETURNS trigger AS  $emp_stamp$
    DECLARE
        d_weight numeric(7,2);
        new_weight numeric(7,2);
    BEGIN
		SELECT WeightInStock INTO d_weight FROM Ingredient WHERE idIngredient = NEW.idIngredient ;
	
        IF NEW.Weight > d_weight THEN
            RAISE EXCEPTION 'There is not enough of this ingredient in stock';
        END IF;
		
		new_weight = d_weight - NEW.Weight;
		raise notice 'New Weight is "%"', new_weight;
		
		UPDATE Ingredient as ing
		SET WeightInStock = new_weight 
		WHERE ing.idIngredient = NEW.idIngredient;

        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER new_topping
BEFORE INSERT OR UPDATE ON ToppingList
FOR EACH ROW
EXECUTE PROCEDURE trigger_ToppingList_before ();

/*2. Когда сотруднику назначается новое значение графика - проверить, что два графика не пересекаются*/


DROP TRIGGER if exists new_schedule on WorkScheduleForEmployee CASCADE;
DROP FUNCTION if exists trigger_WorkScheduleForEmployee_before CASCADE;
CREATE FUNCTION trigger_WorkScheduleForEmployee_before() RETURNS trigger AS  $emp_stamp$
    DECLARE
		rec record;
        n_day character varying(15);
        n_StartWorkTime time without time zone;
        n_EndWorkTime time without time zone;
    BEGIN
		
    	SELECT workingday, StartWorkTime, EndWorkTime INTO n_day, n_StartWorkTime, n_EndWorkTime
			FROM WorkSchedule WHERE idSchedule = NEW.idSchedule;

    	IF EXISTS (select * from WorkSchedule ws
			JOIN
			WorkScheduleForEmployee wsfe
			ON wsfe.idSchedule = ws.idSchedule 
			where idemployee = NEW.idemployee and ws.workingday=n_day and 
			(((n_StartWorkTime < StartWorkTime) and (n_EndWorkTime > StartWorkTime)) or
			((n_StartWorkTime > StartWorkTime) and (n_StartWorkTime < EndWorkTime))))
			THEN
				RAISE EXCEPTION 'There is already a schedule for this time';
			end if;

        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER new_schedule
BEFORE INSERT OR UPDATE ON WorkScheduleForEmployee
FOR EACH ROW
EXECUTE PROCEDURE trigger_WorkScheduleForEmployee_before ();

/*2. Когда сотруднику назначается новое значение графика - проверить, что два графика не пересекаются*/


DROP TRIGGER if exists new_schedule on WorkScheduleForEmployee CASCADE;
DROP FUNCTION if exists trigger_WorkScheduleForEmployee_before CASCADE;
CREATE FUNCTION trigger_WorkScheduleForEmployee_before() RETURNS trigger AS  $emp_stamp$
    DECLARE
		rec record;
        d_StartWorkTime time without time zone;
        d_EndWorkTime time without time zone;
        n_StartWorkTime time without time zone;
        n_EndWorkTime time without time zone;
    BEGIN
		
    	select StartWorkTime, EndWorkTime INTO n_StartWorkTime, n_EndWorkTime
			from WorkSchedule where idSchedule = NEW.idSchedule;

		FOR rec IN (select StartWorkTime, EndWorkTime from WorkSchedule ws
																JOIN
																WorkScheduleForEmployee wsfe
																ON ws.idSchedule = wsfe.idSchedule)
		LOOP

			d_StartWorkTime = rec.StartWorkTime;
			d_EndWorkTime = rec.EndWorkTime;
			IF (n_StartWorkTime < d_StartWorkTime) and (n_EndWorkTime > d_StartWorkTime) or 
				(n_StartWorkTime > d_StartWorkTime) and (n_StartWorkTime < d_EndWorkTime)
			THEN
				raise notice 'New Start is "%"', n_StartWorkTime;
				raise notice 'Old end is "%"', d_EndWorkTime;
				raise notice 'Old Start is "%"', d_StartWorkTime;
				raise notice 'New End is "%"', n_EndWorkTime;
            	RAISE EXCEPTION 'There is already a schedule for this time';
			   END IF;

    	END LOOP;

        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER new_schedule
BEFORE INSERT OR UPDATE ON WorkScheduleForEmployee
FOR EACH ROW
EXECUTE PROCEDURE trigger_WorkScheduleForEmployee_before ();