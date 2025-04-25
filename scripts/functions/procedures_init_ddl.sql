/*
 * Увольнение сотрудника
 */
CREATE OR REPLACE PROCEDURE fire_worker(worker_id INT, worker_name CHAR(256), change_time DATE DEFAULT now()) AS $$
BEGIN
	UPDATE EMPLOYEE e
	SET valid_to = change_time
	WHERE e.name = worker_name AND valid_to IS NULL AND employee_id = worker_id;
END;
$$ LANGUAGE plpgsql;

/*
 * Изменение зарплаты сотрудника
 */
CREATE OR REPLACE PROCEDURE manage_salary(worker_id INT, worker_name CHAR(256), delta INT, is_increase BOOL DEFAULT TRUE) AS $$
BEGIN
	IF NOT is_increase THEN
		delta = -delta;
	END IF;
	UPDATE EMPLOYEE e
	SET salary = salary + delta
	WHERE e.name = worker_name AND employee_id = worker_id;
END;
$$ LANGUAGE plpgsql;
