CALL fire_worker(4, 'Иванов Иван Иванович')

UPDATE EMPLOYEE e
SET valid_to = NULL
WHERE e.name = 'Иванов Иван Иванович'


CALL manage_salary(4, 'Иванов Иван Иванович', 200);
CALL manage_salary(4, 'Иванов Иван Иванович', 200, FALSE);

SELECT * FROM EMPLOYEE
