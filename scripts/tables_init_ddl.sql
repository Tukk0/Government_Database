CREATE TABLE HEAD (
  head_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  title VARCHAR(64) NOT NULL,
  experience INT,
  salary INT,
  valid_from DATE NOT NULL,
  valid_to DATE
);

CREATE TABLE MINISTRY (
  ministry_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  ministry_section VARCHAR(64) NOT NULL,
  head_id INT NOT NULL UNIQUE,
  organisation_id INT,
  FOREIGN KEY (head_id) REFERENCES HEAD(head_id)
);

CREATE TABLE ORGANISATION (
  organisation_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  head_id INT NOT NULL UNIQUE,
  ministry_id INT,
  FOREIGN KEY (head_id) REFERENCES HEAD(head_id),
  FOREIGN KEY (ministry_id) references MINISTRY(ministry_id)
);

CREATE TABLE DEPARTMENT (
  department_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  head_id INT NOT NULL UNIQUE,
  ministry_id INT,
  FOREIGN KEY (head_id) REFERENCES HEAD(head_id),
  FOREIGN KEY (ministry_id) REFERENCES MINISTRY(ministry_id)
);

CREATE TABLE EMPLOYEE (
  employee_id INT PRIMARY KEY,
  name VARCHAR(64) NOT NULL,
  title VARCHAR(64) NOT NULL,
  experience INT,
  salary INT,
  valid_from DATE NOT NULL,
  valid_to DATE,
  department_id INT,
  FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
);
