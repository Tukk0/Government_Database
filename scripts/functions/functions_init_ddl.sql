/*
 * Возвращает список ФИО людей определенной специальности в данном департаменте
 */
CREATE OR REPLACE FUNCTION find_expert(department_name CHAR(256), job_name CHAR(256)) RETURNS TEXT AS $$
DECLARE
	res VARCHAR(512);
	dept_id INT;
	worker_name RECORD;
BEGIN
	dept_id = (SELECT d.department_id FROM DEPARTMENT d WHERE d.name = department_name);
	FOR worker_name IN (
			SELECT e.name 
			FROM EMPLOYEE e 
			WHERE e.department_id = dept_id AND title = job_name
			ORDER BY e.name
		) LOOP
		res = CONCAT(res, worker_name, ', ');
	END LOOP;
	-- Удаляем лишнее ', ' в конце
	IF LENGTH(res) > 1 THEN
		res = LEFT(res, LENGTH(res) - 2);
	END IF;
	-- "Чистим" строку
	res = REPLACE(res, '(', '');
	res = REPLACE(res, ')', '');
	res = REPLACE(res, '"', '');
	RETURN res;
END;
$$ LANGUAGE plpgsql
	STABLE;
