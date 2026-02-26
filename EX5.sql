-- This Transact-SQL script creates all tables that are used in this lab
-- It loads also all data in the four existing tables.

-- NOTE, please !!
-- Create first the database (sample), using CREATE DATABASE statement 

--CREATE DATABASE SAMPLEDB



CREATE TABLE DEPARTMENT(dept_no CHAR(4) ,
                        dept_name CHAR(25) NOT NULL,
                        location CHAR(30) NULL);

CREATE TABLE EMPLOYEE  (emp_no INTEGER PRIMARY KEY, 
                        emp_fname CHAR(20) NOT NULL,
                        emp_lname CHAR(20) NOT NULL,
                        dept_no CHAR(4)
                        );


CREATE TABLE PROJECT   (project_no CHAR(4)  PRIMARY KEY,
                        project_name CHAR(15) NOT NULL,
                        budget NUMERIC (9,3));

CREATE TABLE WORKS_ON	(emp_no INTEGER FOREIGN KEY REFERENCES EMPLOYEE,
                        project_no CHAR(4) FOREIGN KEY REFERENCES PROJECT,
                        job CHAR (15) NULL,
                        enter_date DATE 
                        );
                        

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
--INSERT INTO WORKS_ON VALUES  (29346, 'p4',  'Clerk',     '2017.1.4');

SELECT * FROM EMPLOYEE;
SELECT * FROM PROJECT;
SELECT * FROM DEPARTMENT;
SELECT * FROM WORKS_ON;


--a

--1. Add the missing primary key constraints to this database to maintain entity INTERGRITY

ALTER TABLE DEPARTMENT 
ADD CONSTRAINT DEPARTMENT_DEPT_NO_PK PRIMARY KEY(DEPT_NO)

ALTER TABLE DEPARTMENT 
ALTER COLUMN DEPT_NO CHAR(4) NOT NULL

ALTER TABLE WORKS_ON 
ALTER COLUMN EMP_NO INTEGER NOT NULL


ALTER TABLE WORKS_ON 
ALTER COLUMN PROJECT_NO CHAR(4) NOT NULL

ALTER TABLE WORKS_ON 
ADD CONSTRAINT WORKS_ON_EMP_PROJ_PK PRIMARY KEY(EMP_NO, PROJECT_NO)

--2. Add the missing foreign key constraints to this database to maintain referential integrity

ALTER TABLE EMPLOYEE
ADD CONSTRAINT EMPLOYEE_DEPTNO_KF FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT

--3. The Budget values in PROJECT table must be greater than 10000$ and less than a 150000$ 

SELECT* FROM PROJECT

ALTER TABLE PROJECT 
ADD CONSTRAINT PROJECT_BUDGET_CK CHECK(BUDGET > 10000 AND BUDGET < 1500000)

--4. No two projects with the same names in PROJECT table 

ALTER TABLE PROJECT 
ADD CONSTRAINT PROJECT_NAME_UQ UNIQUE (PROJECT_NAME)

--5. Change the first and last name columns in EMPLOYEE table, so the columns will
--have VARCHAR datatype with length 40

ALTER TABLE EMPLOYEE
ALTER COLUMN EMP_FNAME VARCHAR(40) NOT NULL
ALTER TABLE EMPLOYEE
ALTER COLUMN EMP_LNAME VARCHAR(40) NOT NULL

--6. Add the column telephone_no to the EMPLOYEE table.

ALTER TABLE EMPLOYEE
ADD TELEPHONE_NO CHAR(10) 

--7. Remove the telephone_no column, which was added to the EMPLOYEE table

ALTER TABLE EMPLOYEE
DROP COLUMN TELEPHONE_NO  


--B

--1. Insert the data of a new employee called Julia Long, whose employee number is 11111. Her
--department number is not known yet.

INSERT INTO EMPLOYEE 
VALUES(11111, 'JULIA', 'LONG', NULL)

SELECT* FROM EMPLOYEE

--2. Create a new table called emp_d1_d2 with all employees who work for department d1 or d2
--and load the corresponding rows from the employee table. Find two different, but equivalent,
--solutions.

CREATE TABLE emp_d1_d2 (emp_no INTEGER PRIMARY KEY, 
                        emp_fname CHAR(20) NOT NULL,
                        emp_lname CHAR(20) NOT NULL,
                        dept_no CHAR(4)
                        );

INSERT INTO emp_d1_d2
SELECT* FROM EMPLOYEE
WHERE DEPT_NO IN ('D1', 'D2')

SELECT* FROM emp_d1_d2

--OTHER SOLUTION

SELECT* 
INTO NEW_emp_d1_d2
FROM EMPLOYEE
WHERE DEPT_NO IN ('D1', 'D2')

SELECT* FROM emp_d1_d2

--3. Modify the job of all employees in project p1 who are managers. They have to work as clerks
--from now on

UPDATE WORKS_ON 
SET JOB = 'CLERK'
WHERE PROJECT_NO = 'P1' AND JOB ='MANAGER'

SELECT* FROM WORKS_ON

--4. Modify the jobs of the employee with employee number 28559. From now on she will be the
--nager for all her projects.

UPDATE WORKS_ON
SET JOB ='MANAGER'
WHERE EMP_NO = 28559

--5. Increase the budget for all projects. The increase is 10 percent

UPDATE PROJECT
SET BUDGET = BUDGET * 1.1

--6. Delete the Research department. Can you delete it? Why/Why not? What would be your
--lution?

DELETE FROM DEPARTMENT
WHERE dept_name = 'RESEARCH'

ALTER TABLE EMPLOYEE
ALTER CONSTRAINT EMPLOYEE_DEPTNO_KF FOREIGN KEY (DEPT_NO) REFERENCES DEPARTMENT ON DELETE SET NULL


SELECT* FROM DEPARTMENT
SELECT* FROM EMPLOYEE
