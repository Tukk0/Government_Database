REATE TABLE HEAD (
  head_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  title VARCHAR(64) NOT NULL,
  experience INT,
  salary INT,
  valid_from DATE NOT NULL,
  valid_to DATE
);

CREATE TABLE EMPLOYEE (
  employee_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  title VARCHAR(64) NOT NULL,
  experience INT,
  salary INT,
  valid_from DATE NOT NULL,
  valid_to DATE
);

CREATE TABLE DEPARTMENT (
  department_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  head_id INT NOT NULL UNIQUE,
  employee_id INT,
  FOREIGN KEY (head_id) REFERENCES HEAD(head_id),
  FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
);

CREATE TABLE ORGANISATION (
  organisation_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  head_id INT NOT NULL UNIQUE,
  department_id INT,
  FOREIGN KEY (head_id) REFERENCES HEAD(head_id),
  FOREIGN KEY (department_id) references DEPARTMENT(department_id)
);

CREATE TABLE MINISTRY (
  ministry_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  ministry_section VARCHAR(64) NOT NULL,
  head_id INT NOT NULL UNIQUE,
  organisation_id INT,
  department_id INT,
  FOREIGN KEY (head_id) REFERENCES HEAD(head_id),
  FOREIGN KEY (organisation_id) REFERENCES ORGANISATION(organisation_id),
  FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
)
