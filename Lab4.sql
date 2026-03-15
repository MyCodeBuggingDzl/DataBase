-- This Transact-SQL script creates all tables that are used in this lab
-- It loads also all data in the four existing tables.

-- NOTE, please !!
-- Create first the database (sample), using CREATE DATABASE statement 

--CREATE DATABASE Lab4
--USE Lab4

CREATE TABLE DEPARTMENT(dept_no CHAR(4) PRIMARY KEY,
                        dept_name CHAR(25) NOT NULL,
                        location CHAR(30) NULL);

CREATE TABLE EMPLOYEE  (emp_no INTEGER PRIMARY KEY, 
                        emp_fname CHAR(20) NOT NULL,
                        emp_lname CHAR(20) NOT NULL,
                        dept_no CHAR(4), 
                        CONSTRAINT EMPLOYEE_DEPT_NO_FK FOREIGN KEY (dept_no) REFERENCES DEPARTMENT);


CREATE TABLE PROJECT   (project_no CHAR(4)  PRIMARY KEY,
                        project_name CHAR(15) NOT NULL,
                        budget NUMERIC (9,3));

CREATE TABLE WORKS_ON	(emp_no INTEGER FOREIGN KEY REFERENCES EMPLOYEE,
                        project_no CHAR(4) FOREIGN KEY REFERENCES PROJECT,
                        job CHAR (15) NULL,
                        enter_date DATE ,
                        PRIMARY KEY (EMP_NO, PROJECT_NO));
                        

INSERT INTO DEPARTMENT VALUES  ('d1', 'Research',   'Dallas');
INSERT INTO DEPARTMENT VALUES  ('d2', 'Accounting', 'Seattle');
INSERT INTO DEPARTMENT VALUES  ('d3', 'Marketing',  'Dallas');

INSERT INTO EMPLOYEE VALUES(25348, 'Matthew', 'Smith',    'd3');
INSERT INTO EMPLOYEE VALUES(10102, 'Ann',     'Jones',    'd3');
INSERT INTO EMPLOYEE VALUES(18316, 'John',    'Barrimore','d1');
INSERT INTO EMPLOYEE VALUES(29346, 'James',   'James',    'd2');
INSERT INTO EMPLOYEE VALUES(9031,  'Elke',    'Hansel',   'd2');
INSERT INTO EMPLOYEE VALUES(2581,  'Elsa',    'Bertoni',  'd2');
INSERT INTO EMPLOYEE VALUES(28559, 'Sybill',  'Moser',    'd1');
INSERT INTO EMPLOYEE VALUES(28557, 'Alix',    'Sonu',    'd1');



INSERT INTO PROJECT VALUES  ('p1', 'Apollo', 120000.00);
INSERT INTO PROJECT VALUES  ('p2', 'Gemini', 95000.00);
INSERT INTO PROJECT VALUES  ('p3', 'Mercury', 186500.00);
INSERT INTO PROJECT VALUES  ('p5', 'Melets', 186500.00);
INSERT INTO PROJECT VALUES  ('p6', 'Gaoeez', 206500.00);
INSERT INTO PROJECT VALUES  ('p7', 'Future', 346500.00);

INSERT INTO WORKS_ON VALUES  (10102, 'p1',  'Analyst',   '2016.10.1');
INSERT INTO WORKS_ON VALUES  (10102, 'p3',  'Manager',   '2018.1.1');
INSERT INTO WORKS_ON VALUES  (25348, 'p2',  'Clerk',     '2017.2.15');
INSERT INTO WORKS_ON VALUES  (18316, 'p2',  NULL,        '2017.6.1');
INSERT INTO WORKS_ON VALUES  (29346, 'p2',  NULL,        '2016.12.15');
INSERT INTO WORKS_ON VALUES  (2581,  'p3',  'Analyst',   '2017.10.15');
INSERT INTO WORKS_ON VALUES  (9031,  'p1',  'Manager',   '2017.4.15');
INSERT INTO WORKS_ON VALUES  (28559, 'p1',  NULL,        '2017.8.1');
INSERT INTO WORKS_ON VALUES  (28559, 'p2',  'Clerk',     '2018.2.1');
INSERT INTO WORKS_ON VALUES  (9031,  'p3',  'Clerk',     '2016.11.15');  
INSERT INTO WORKS_ON VALUES  (29346, 'p1',  'Clerk',     '2017.1.4');

SELECT * FROM EMPLOYEE;
SELECT * FROM PROJECT;
SELECT * FROM DEPARTMENT;
SELECT * FROM WORKS_ON;



--1

SELECT EMP_FNAME, EMP_LNAME
FROM EMPLOYEE
WHERE DEPT_NO IN (SELECT DEPT_NO
                FROM DEPARTMENT
                WHERE DEPT_NAME = 'Research')

--2

SELECT *
FROM EMPLOYEE
WHERE dept_no IN (SELECT dept_no
                FROM DEPARTMENT 
                WHERE location = 'Dallas')

--3

SELECT PROJECT_NAME
FROM PROJECT
WHERE PROJECT_NO IN (SELECT PROJECT_NO
                       FROM PROJECT
                       WHERE BUDGET = 120000)

--4

SELECT EMP_FNAME, EMP_LNAME
FROM EMPLOYEE
WHERE DEPT_NO IN (SELECT dept_no
                   FROM employee
                   WHERE EMP_lNAME = 'Barrimore'
                   and emp_fname  = 'John')

--5

SELECT EMP_FNAME, EMP_LNAME
FROM EMPLOYEE
WHERE EMP_FNAME IN (SELECT EMP_FNAME
                FROM EMPLOYEE
                WHERE DEPT_NO = '29346')

--6

SELECT emp_fname, emp_lname
from employee
where emp_no in (select emp_no
                from works_on
                where project_no not like 'p2')

--7

select project_name
from project
where budget in (select MAX(budget)
                       from project)

--8

select project_name
from project p 
where not exists (select project_no
                        from works_on w
                        where emp_no is null)

--9 

select emp_fname, emp_lname
from employee
where emp_no in (select emp_no
                from works_on
                where enter_date = '2017-01-04')

---9

select emp_no
from works_on w
where exists (select project_no
                from project p
                where p.budget > 150000)