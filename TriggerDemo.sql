--CREATE DATABASE TRIGGER_DEMO
--USE TRIGGER_DEMO

CREATE TABLE EMPLOYEE
(
ID INT PRIMARY KEY,
NAME VARCHAR(30),
SALARY INT,
GENDER VARCHAR(10),
DEPARTMENT_NAME VARCHAR(20)
)
GO
-- Insert data into Employee table
INSERT INTO Employee VALUES (1,'Papero', 5000, 'Male', 'Finance')
INSERT INTO Employee VALUES (2,'Priyanka', 5400, 'Female', 'IT')
INSERT INTO Employee VALUES (3,'Anurag', 6500, 'male', 'IT')
INSERT INTO Employee VALUES (4,'Samon', 4700, 'Male', 'HR')
INSERT INTO Employee VALUES (5,'Hina', 6600, 'Female', 'Finance')


CREATE TABLE Audit_Log (
LogID INT PRIMARY KEY IDENTITY,
Action VARCHAR(50),
TableName VARCHAR(50),
RecordID INT,
 LogDate DATETIME,
 UserId VARCHAR (40),
 Application_Name VARCHAR (50) ); 


-- 3. Create After Trigger named trg_insert_log. Inside the trigger, you determine the action
--performed (INSERT, UPDATE, or DELETE). Then insert a record into the Audit_Log table
--recording the action, table name, affected record ID, and the date/time of the action. This
--trigger will be fired, whenever a new Employee is added, updated, or deleted to the system.
--Use COALESCE: It is a function in SQL that returns the first non-null expression among its
--arguments

CREATE TRIGGER trg_insert_log
ON EMPLOYEE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @ACTION VARCHAR(20)
IF EXISTS ( SELECT 1 FROM INSERTED)
	IF EXISTS (SELECT 1 FROM DELETED)
		SET @ACTION = 'UPDATE'
	ELSE
		SET @ACTION = 'INSERTED'
	ELSE
		SET @ACTION = 'DELETED'

insert into Audit_Log
SELECT  @ACTION, 'EMPLOYEE',COALESCE(I.ID, D.ID), GETDATE(), SYSTEM_USER, APP_NAME()
FROM INSERTED I FULL JOIN DELETED D
ON I.ID = D.ID

END

----4. Test your trigger by inserting the following row in the "Employee" table: (Insert into
--Employee the VALUES(6,'Rahul',20000,'Female','Finance'). The trigger will be
--executed automatically. Check both tables and see. Try also update and delete operations

Insert into Employee VALUES (6,'Rahul',20000,'Female','Finance')

SELECT* FROM Audit_Log

UPDATE EMPLOYEE
SET SALARY = 30000
WHERE ID = 6

DELETE EMPLOYEE
WHERE ID = 6

--5. ALTER the preceding After Trigger (trg_insert_log) to be an INSTEAD OF trigger that executes
--DML into the " Audit_Log " table when we fire the insertion, updating or deleting query into
--the "Employee" table. Test the trigger by inserting into Employee table the VALUES
--(7,'Bansal',10000,'male','IT') then run:
select * from Employee
select * from Audit_Log
--As you can see, the data was not inserted into the "Employee" table, that is why it is called
--an INSTEAD OF trigger, it does something else instead of the main thing

DROP TRIGGER trg_insert_log
ON EMPLOYEE
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
DECLARE @ACTION VARCHAR(20)
IF EXISTS ( SELECT 1 FROM INSERTED)
	IF EXISTS (SELECT 1 FROM DELETED)
		SET @ACTION = 'UPDATE'
	ELSE
		SET @ACTION = 'INSERTED'
	ELSE
		SET @ACTION = 'DELETED'

insert into Audit_Log
SELECT  @ACTION, 'EMPLOYEE',COALESCE(I.ID, D.ID), GETDATE(), SYSTEM_USER, APP_NAME()
FROM INSERTED I FULL JOIN DELETED D
ON I.ID = D.ID

END

insert into EmployeE VALUES(7,'Bansal',10000,'male','IT')


--6. Create a trigger named trg_delemployee_record that should print 'DONT have
--permission to delete from that table' instead of deleting the row containing the
--employee name 'Pranaya' row from Employee table, the message in the trigger will be
--displayed. Use RAISERROR to Raise custom error message

DROP TRIGGER trg_delemployee_record
ON EMPLOYEE
INSTEAD OF DELETE
AS
BEGIN
	IF EXISTS ( SELECT 1 FROM EMPLOYEE WHERE NAME = (SELECT NAME FROM deleted
	WHERE NAME = 'Samon'))
	RAISERROR ('DONT have permission to delete from that table', 16, 1)
else 
	DELETE FROM EMPLOYEE WHERE NAME = (SELECT NAME FROM DELETED)
END
--FIRE TRIGGER
DELETE FROM EMPLOYEE WHERE NAME = 'Samon'


--7. Create a trigger trg_employee_res which should restrict the INSERT operation on the
--Employee table. To do so, you are simply rollback the transaction which will roll back the
--insert statement. PRINT 'YOU CANNOT PERFORM INSERT OPERATION'. Test your trigger by
--inserting the following: INSERT INTO Employee VALUES (8, ‘Saroj’, 7600, ‘Male’, ‘IT’)

DROP TRIGGER trg_employee_res 
ON EMPLOYEE
AFTER INSERT 
AS
BEGIN
	ROLLBACK TRAN
	PRINT 'YOU CANNOT PERFORM INSERT OPERATION' 
END

BEGIN TRAN
INSERT INTO Employee VALUES (8, 'Saroj', 7600, 'Male', 'IT')


--8. Create a trigger trg_reminder that prints a message to the client when anyone tries to add or
--change data in the Employee table 

CREATE TRIGGER trg_reminder 
ON EMPLOYEE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	ROLLBACK TRANSACTION 
	--.............








--9


CREATE TABLE Department
(
Dept_name VARCHAR(20) primary key,
Dept_location VARCHAR(30)
)
INSERT INTO Department VALUES ('Finance', 'LONDON')
INSERT INTO Department VALUES ('IT','NEW YORK')
INSERT INTO Department VALUES ('HR','MONTREAL')
INSERT INTO Department VALUES ('ADMIN.','MONTREAL')


ALTER TABLE EMPLOYEE
ADD CONSTRAINT EMP_DEPT_NAME FOREIGN KEY (Department_Name) REFERENCES Department

CREATE TRIGGER TGR_DEP
ON DEPARMENT
INSTEAD OF DELETE
		IF EXISTS( SELECT 1 FROM EMPLOYEE WHERE DEPARTMENT_NAME = (SELECT DEPT_NAME FROM DELETED)
			RAISERROR ('CANNOT DELETE', 16, 1)
		ELSE
			DELETE Department
			WHERE Dept_name = (SELECT DEPT_NAME FROM DELETED)

END

SELECT* FROM Department


DELETE FROM DEPARTMENT WHERE DEPT_NAME = 'ADMIN'

DELETE FROM DEPARTMENT WHERE DEPT_NAME = 'IT'