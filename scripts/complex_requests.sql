/* 
 Вывести 5 департаментов с самой низкой средней зарплатой среди департаментов, 
 средняя зарплата работников которых больше 4000
 в порядке возрастания средней зарплаты
*/
SELECT name, avg(salary) as average_salary
FROM
	(
	SELECT DEPARTMENT.name as name, salary
	FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON EMPLOYEE.department_id = DEPARTMENT.department_id
	)
WHERE name IS NOT NULL
GROUP BY name
HAVING avg(salary) > 4000
ORDER BY average_salary
LIMIT 5;


/*
 Вывести список работников, в данный момент находящихся
 в подчинении Артёма Удовенко
 (список работников департаментов и организаций под контролем
 его министерства)
*/
WITH AllDepartments AS (
	WITH PersonMinistryID AS (
		SELECT ministry_id
		FROM
		(
			SELECT MINISTRY.head_id, ministry_id, HEAD.name
			FROM HEAD
			RIGHT JOIN MINISTRY ON MINISTRY.head_id = HEAD.head_id
		)
		WHERE name = 'Удовенко Артём Ильич'
	), OrganisationsID AS (
		SELECT organisation_id
		FROM ORGANISATION
		WHERE ministry_id = (SELECT * FROM PersonMinistryID)
	), DepartmentsID AS (
		SELECT department_id
		FROM DEPARTMENT
		WHERE ministry_id IN (SELECT * FROM PersonMinistryID) or organisation_id in (SELECT * FROM OrganisationsID)
	) 
	SELECT * FROM DepartmentsID
	UNION
	SELECT * FROM OrganisationsID
	)
SELECT employee_id, name
FROM EMPLOYEE
WHERE department_id IN (SELECT * FROM AllDepartments) AND valid_to IS NULL;


/*
 Вывести 8 работников c самым большим стажем, работающих в сфере экологии и развития общества
 (ID, ФИО, должность, опыт и даты работы)
*/
WITH ECOLOGY_MINISTRIES AS (
	SELECT ministry_id
	FROM MINISTRY
	WHERE ministry_section = 'Экология и развитие общества'
), ECOLOGY_ORGANISATIONS AS (
	SELECT organisation_id
	FROM ORGANISATION
	WHERE ministry_id IN (SELECT * FROM ECOLOGY_MINISTRIES)
), ECOLOGY_DEPARTMENTS AS (
	SELECT department_id
	FROM DEPARTMENT
	WHERE ministry_id IN (SELECT * FROM ECOLOGY_MINISTRIES) or organisation_id IN (SELECT * FROM ECOLOGY_ORGANISATIONS)
)
SELECT employee_id, name, title, experience, valid_from, valid_to
FROM EMPLOYEE
WHERE department_id in (SELECT * FROM ECOLOGY_DEPARTMENTS)
ORDER BY experience DESC
LIMIT 8;


/*
  Вывести список топ 12 инженеров с самым большим стажем (ID, ФИО, должность, стаж), 
  у которых непосредственный руководитель (т.е. департамента) имеет стаж более 10 лет
*/
WITH EXPERIENCED_HEADS AS (
	SELECT head_id
	FROM HEAD
	WHERE experience > 10
), DEPARTMENTS_WITH_HEADS AS (
	SELECT department_id
	FROM department
	WHERE head_id IN (SELECT * FROM EXPERIENCED_HEADS)
)
SELECT employee_id, name, title, experience
FROM EMPLOYEE
WHERE department_id IN (SELECT * FROM DEPARTMENTS_WITH_HEADS) and
	  title LIKE '%инженер%' OR title LIKE '%Инженер%'
ORDER BY experience DESC
LIMIT 12;


/*
  Вывести для каждого департамента, относящегося к министерствам блока "Знания и прогресс"
  сотрудников с самой высокой зарплатой (5 самых высоких зарплат, если у сотрудников зарплата
  совпадает, и они имеют ранг <= 5, вывести их всех)
  (Департамент, ФИО, зарплата, ранг по зарплате)
*/
WITH KNOWLEDGE_MINISTRIES AS (
	SELECT ministry_id
	FROM MINISTRY
	WHERE ministry_section = 'Знания и прогресс'
), KNOWLEDGE_ORGANISATIONS AS (
	SELECT organisation_id
	FROM ORGANISATION
	WHERE ministry_id IN (SELECT * FROM KNOWLEDGE_MINISTRIES)
), KNOWLEDGE_DEPARTMENTS AS (
	SELECT department_id, name as department_name
	FROM DEPARTMENT
	WHERE ministry_id IN (SELECT * FROM KNOWLEDGE_MINISTRIES) or organisation_id IN (SELECT * FROM KNOWLEDGE_ORGANISATIONS)
), RANKED_EMPLOYEES AS (
    SELECT 
        kd.department_name,
        e.name AS employee_name,
        e.salary,
        DENSE_RANK() OVER (PARTITION BY kd.department_id ORDER BY e.salary DESC) AS salary_rank
    FROM EMPLOYEE e
    JOIN KNOWLEDGE_DEPARTMENTS kd ON e.department_id = kd.department_id
)
SELECT department_name, employee_name, salary, salary_rank
FROM RANKED_EMPLOYEES
WHERE salary_rank <= 5
ORDER BY department_name, salary_rank;
