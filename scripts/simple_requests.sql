-- Вывести список текущих и бывших министров, их ID, имена и даты работы
SELECT head_id as id, name, valid_from, valid_to
FROM HEAD
WHERE title = 'Министр';

-- Вывести для каждого департамента его название и ФИО руководителя
-- Список отсортировать в алфавитном порядке названий департаментов
SELECT d.name, h.name
FROM DEPARTMENT d
JOIN HEAD h ON h.head_id = d.head_id
ORDER by d.name

-- Вывести ID и названия всех министерств из социальной сферы
SELECT ministry_id, name
FROM MINISTRY
WHERE ministry_section = 'Социальная сфера';

/*
  Вывести список ФИО работников с зарплатой больше 5000, работающих в министерствах,
  для каждого указать зарплату и министерство.
  Список должен быть отсортирован по убыванию зарплаты, вывести всех, кроме первых 15.
 */
SELECT e.name AS employee_name, e.salary, m.name AS ministry_name
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.department_id = d.department_id
JOIN MINISTRY m ON d.ministry_id = m.ministry_id
WHERE e.salary > 5000
ORDER BY e.salary DESC
OFFSET 15;

-- Вывести общее число аналитиков в системе
SELECT count(employee_id)
FROM EMPLOYEE
WHERE title LIKE '%аналитик%' OR title LIKE '%Аналитик%';
