/*
 * Все работники социальной сферы в алфавитном порядке
 */
CREATE OR REPLACE
	VIEW SOCIAL_WORKERS AS
		WITH SOCIAL_MINISTRIES AS (
			SELECT ministry_id
			FROM MINISTRY
			WHERE ministry_section = 'Социальная сфера'
		), SOCIAL_ORGANISATIONS AS (
				SELECT organisation_id
				FROM ORGANISATION
				WHERE ministry_id IN (SELECT * FROM SOCIAL_MINISTRIES)
		), SOCIAL_DEPARTMENTS AS (
				SELECT department_id
				FROM DEPARTMENT
				WHERE ministry_id IN (SELECT * FROM SOCIAL_MINISTRIES) or organisation_id IN (SELECT * FROM SOCIAL_ORGANISATIONS)
		)
		SELECT employee_id, name, title, experience, valid_from, valid_to
		FROM EMPLOYEE
		WHERE department_id in (SELECT * FROM SOCIAL_DEPARTMENTS)
		ORDER BY name;

/*
 * Cписок кандидатов на повышение из данного департамента
 * Ищем кандидатов с высоким стажем и наиболее низкой зарплатой
 */
CREATE TEMP
	VIEW CANDIDATES_FOR_PROMOTION AS
		WITH dept_id AS (
			SELECT department_id as id
			FROM DEPARTMENT
			WHERE name = 'Отдел взрослой медицины'
		)
		SELECT employee_id, name, title, experience, salary
		FROM EMPLOYEE
		WHERE department_id IN (SELECT * FROM dept_id) AND valid_to IS NULL AND experience > 5
		ORDER BY experience DESC, SALARY;

/*
 * Список всех руководителей, их зарплат, должностей и стажа
 * (Безименная антикоррупционная разведка)
 */
CREATE OR REPLACE TEMP
	VIEW ALL_HEADS AS
		SELECT head_id, salary, experience, title
		FROM HEAD
		ORDER BY salary DESC, experience, title

/*
 * Список ID работников администрации труда для проведения лотереи
 */
CREATE TEMP
	VIEW LOTTERY AS
		WITH LABOUR_MINISTRY_ID AS (
			SELECT ministry_id
			FROM MINISTRY
			WHERE name = 'Администрация труда'
		), LABOUR_ORGANISATIONS AS (
				SELECT organisation_id
				FROM ORGANISATION
				WHERE ministry_id IN (SELECT * FROM LABOUR_MINISTRY_ID)
		), LABOUR_DEPARTMENTS AS (
				SELECT department_id
				FROM DEPARTMENT
				WHERE ministry_id IN (SELECT * FROM LABOUR_MINISTRY_ID) or organisation_id IN (SELECT * FROM LABOUR_ORGANISATIONS)
		)
		SELECT employee_id
		FROM EMPLOYEE
		WHERE department_id IN (SELECT * FROM LABOUR_DEPARTMENTS)
