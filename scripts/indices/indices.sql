CREATE INDEX employee_id_ind ON EMPLOYEE(employee_id);

EXPLAIN (ANALYZE)
SELECT employee_id
FROM EMPLOYEE
WHERE employee_id = 435;
/*
 * Используя 
 * employee_id_name_ind (Index Only Scan)
 * cost=0.27..8.29
 * Planning Time: 1.394 ms
 * Execution Time: 0.197 ms
 * 
 * Используя
 * employee_pkey (Index Only Scan)
 * cost=0.27..8.29
 * Planning Time: 0.869 ms
 * Execution Time: 0.195 ms
 * 
 * Разницы почти нет, индекс такой же, что и по умолчанию
 */

DROP INDEX IF EXISTS employee_id_ind;

------------------------------------------------------------

CREATE INDEX employee_experience_salary_ind ON 
EMPLOYEE (experience, salary)

EXPLAIN (ANALYZE)
SELECT experience, salary
FROM EMPLOYEE
WHERE experience = 5 AND salary < 4000
/*
 * Используя индекс
 * Bitmap Heap Scan -> Bitmap Index Scan
 * cost=4.38..14.00
 * Planning Time: 1.536 ms
 * Execution Time: 0.044 ms
 * 
 * Seq Scan 
 * cost=0.00..16.16
 * Planning Time: 0.841 ms
 * Execution Time: 0.088 ms
 * 
 * Разница незначительна, так как объемы данных слишком малы
 * (около 500 записей)
 */

DROP INDEX IF EXISTS employee_experience_salary_ind;

------------------------------------------------------------

CREATE INDEX employee_ultimate_ind ON
EMPLOYEE (title, salary, experience, valid_from)

EXPLAIN (ANALYZE)
SELECT (title, salary, experience, valid_from)
FROM EMPLOYEE
WHERE title = 'Руководитель' AND salary > 2000 AND experience < 7 AND valid_from > '2013-07-18'
/*
 * Используя индекс
 * Index Only Scan
 * cost=0.27..8.30
 * Planning Time: 1.709 ms
 * Execution Time: 0.046 ms
 * 
 * Seq Scan 
 * cost=0.00..18.54
 * Planning Time: 1.195 ms
 * Execution Time: 0.165 ms
 * 
 * Разница чуть более заметна, но все же невелика
 */

DROP INDEX IF EXISTS employee_ultimate_ind;
