SELECT *
FROM Person.Person;



--Why should schema names be specified before table names in SQL Server?
--To improve readability and when it avoids ambiguity when there's a table with the same name.

--• How many schemas are present in your installed AdventureWorks database?
--There's 7 schemas

--PART 2



select* from HumanResources.Employee select* from HumanResources.EmployeeDepartmentHistory select* from Person.Person
--1. Create a stored procedure that accepts a department ID as a parameter and returns a list of
--employees who work in that department. Include the employee's first name, last name, and
--job title.

Create Procedure empByDept @deptID int 
As
Begin
		Select p.FirstName, p.LastName, h.JobTitle 
		from HumanResources.Employee h join Person.Person p
		on h.BusinessEntityID = p.BusinessEntityID
		join HumanResources.EmployeeDepartmentHistory e
		on p.BusinessEntityID = e.BusinessEntityID
		where DepartmentID = @deptID
End

EXEC empByDept @deptID = 1



select* from HumanResources.EmployeePayHistory select* from HumanResources.Employee
----2. Create a stored procedure that takes the employee's EmployeeID and a new salary amount
--as input and updates the salary of the employee in the HumanResources.Employee table

Create Procedure empSalary @empID int, @newSalary MONEY
As
Begin
	Update HumanResources.EmployeePayHistory
	Set Rate = @newSalary, ModifiedDate = GETDATE()
	Where BusinessEntityID = @empID
End

EXEC empSalary @empID = 1, @NewSalary = 75.00;
	


select* from Production.Product
--3. Create a stored procedure that inserts a new product into the Production.Product table.

Create Procedure newProduct @name varchar(20), @productNum varchar(10), @standardCost MONEY, @ListPrice MONEY
As
Begin
	Insert into  Production.Product (Name, ProductNumber,MakeFlag,FinishedGoodsFlag,SafetyStockLevel,ReorderPoint,StandardCost,
     ListPrice,DaysToManufacture,SellStartDate,rowguid,ModifiedDate) values (@Name, @productNum, 1, 1, 100, 10, @StandardCost, @ListPrice, 0,
     GETDATE(),NEWID(),GETDATE())
End

EXEC newProduct @Name = 'Gaming Mouse', @productNum = 'GM-1001',  @StandardCost = 35.00, @ListPrice = 79.99;



select* from 
--4. Create a trigger that logs any changes to the Salary field of the HumanResources.Employee
--table. This trigger should insert a record into a new table called SalaryChangeLog whenever
--an employee's salary is updated.

CREATE TABLE SalaryChangeLog
(LogID INT IDENTITY(1,1) PRIMARY KEY,
BusinessEntityID INT,
OldSalary MONEY,
NewSalary MONEY,
ChangeDate DATETIME DEFAULT GETDATE())

CREATE TRIGGER trg_LogSalaryChanges
ON HumanResources.EmployeePayHistory
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Rate)
    BEGIN
        INSERT INTO SalaryChangeLog
        (
            BusinessEntityID,
            OldSalary,
            NewSalary,
            ChangeDate
        )
        SELECT
            d.BusinessEntityID,
            d.Rate,
            i.Rate,
            GETDATE()
        FROM deleted d join inserted i
            ON d.BusinessEntityID = i.BusinessEntityID
        WHERE d.Rate <> i.Rate;
    END
END;

UPDATE HumanResources.EmployeePayHistory
SET Rate = 80.00
WHERE BusinessEntityID = 1


SELECT * FROM SalaryChangeLog




----5. Create a trigger that prevents any updates to the Quantity field in the
--Production.ProductInventory table that would result in a negative inventory quantity.

Create Trigger Trg_NoUpd
On Production.ProductInventory
Instead of Update
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE Quantity < 0
    )
    BEGIN
        RAISERROR('Inventory quantity cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE pi
    SET pi.Quantity = i.Quantity
    FROM Production.ProductInventory pi
    INNER JOIN inserted i
        ON pi.ProductID = i.ProductID
       AND pi.LocationID = i.LocationID;
END


select* from Production.Product
----6. Create a stored procedure that deletes products from the Production.Product table that
--were added before a given date.

ALTER PROCEDURE DeleteOldProducts
    @CutoffDate DATETIME
AS
BEGIN
    DELETE FROM Production.Product
    WHERE SellStartDate < @CutoffDate
      AND ProductID NOT IN
			
          (SELECT ProductAssemblyID
          FROM Production.BillOfMaterials
          WHERE ProductAssemblyID IS NOT NULL
          UNION
          SELECT ComponentID
          FROM Production.BillOfMaterials
          WHERE ComponentID IS NOT NULL)
END
