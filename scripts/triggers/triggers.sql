CREATE FUNCTION get_sirname(name char(256)) RETURNS char(256) AS $$
DECLARE
	sirname char(256);
BEGIN
	sirname = SPLIT_PART(name, ' ', 1);
	RETURN sirname;
END;
$$ LANGUAGE plpgsql
	STABLE;

CREATE TABLE CONFLICTS (
  employee_id INT PRIMARY KEY,
  name VARCHAR(256) NOT NULL,
  title VARCHAR(256) NOT NULL,
  experience INT,
  salary INT,
  valid_from DATE NOT NULL,
  valid_to DATE,
  department_id INT,
  FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
);

DROP TABLE CONFLICTS CASCADE;

/*
 * Сканирует систему на однофамильцев
 * (предотвращение конфликта интересов)
 */
CREATE OR REPLACE FUNCTION search_for_conflict() RETURNS TRIGGER AS $$
DECLARE
	sirname char(256);
	id INT;
	empl record;
BEGIN
	sirname = get_sirname(NEW.name);
	id = NEW.employee_id;

	INSERT INTO CONFLICTS
	SELECT *
    FROM EMPLOYEE
    WHERE get_sirname(name) = sirname AND employee_id != NEW.employee_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER conflict_finder
    AFTER INSERT ON EMPLOYEE
    FOR EACH ROW
EXECUTE FUNCTION search_for_conflict();

INSERT INTO EMPLOYEE (employee_id, name, title, experience, salary, valid_from, valid_to, department_id) VALUES
(999, 'Иванов Артем Игоревич', 'Инженер-электрик', 6, 5900, '2018-09-11', NULL, 27);

SELECT * FROM CONFLICTS;

DROP FUNCTION search_for_conflict()

DROP TRIGGER conflict_finder ON EMPLOYEE

------------------------------------------------------------
/*
 * Выдает предупреждение о том, что министерства можно добавлять
 * только после специального согласования
 */
CREATE OR REPLACE FUNCTION ministry_warner() RETURNS TRIGGER AS $$
BEGIN
	NEW.name := NEW.name || ' (Добавление требует согласования)';
    RAISE NOTICE 'Внимание! Добавление министерств запрещено без согласования с высшими правительственными институтами';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ministry_adder
	BEFORE INSERT ON MINISTRY
	FOR EACH ROW
EXECUTE FUNCTION ministry_warner();

INSERT INTO HEAD (head_id, name, title, experience, salary, valid_from, valid_to) VALUES
	(999, 'Иванов Артем Игоревич', 'Директор тестов', 6, 5900, '2018-09-11', NULL);

INSERT INTO MINISTRY (ministry_id, name, ministry_section, head_id) VALUES
	(999, 'Администрация тестов', 'Знания и прогресс', 999);

DELETE FROM MINISTRY WHERE ministry_id = 999;

SELECT * FROM MINISTRY;

------------------------------------------------------------
/*
 * Выдает предупреждение о том, что вместе с удалением департамента
 * требуется изменения статуса его руководителя
 */
CREATE OR REPLACE FUNCTION department_warner_r() RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Внимание! Удаление департамента требует переназначения его главы! Его ID: %', OLD.head_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER department_remover
	AFTER DELETE ON DEPARTMENT
	FOR EACH ROW
EXECUTE FUNCTION department_warner_r();

INSERT INTO HEAD (head_id, name, title, experience, salary, valid_from, valid_to) VALUES
	(999, 'Иванов Артем Игоревич', 'Директор тестов', 6, 5900, '2018-09-11', NULL);

INSERT INTO DEPARTMENT (department_id, name, head_id, ministry_id, organisation_id) VALUES
	(9999,'Департамент тестов', 999, 1, NULL);

DELETE FROM DEPARTMENT WHERE department_id = 9999;
DELETE FROM HEAD WHERE head_id = 999;
