--*************************************************************************--
-- Title: Assignment06
-- Author: LisaJones
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2020-08-12,LisaJones,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_LisaJones')
	 Begin 
	  Alter Database [Assignment06DB_LisaJones] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_LisaJones;
	 End
	Create Database Assignment06DB_LisaJones;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_LisaJones;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers ******************************
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'*/


-- Question 1 (5 pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

-- CATEGORIES VIEW
go
Create --  drop
View vCategoryTable
With Schemabinding
AS
	Select CategoryID, CategoryName
	From dbo.Categories
go

go
Select * From vCategoryTable
go

-- PRODUCTS VIEW
go
Create --  drop
View vProductTable
With Schemabinding
AS
	Select ProductID, ProductName, CategoryID, Unitprice
	From dbo.Products
go

go
Select * From vProductTable
go

-- EMPLOYEES VIEW
go
Create --  drop
View vEmployeeTable
With Schemabinding
AS
	Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
	From dbo.Employees
go

go
Select * From vEmployeeTable
go

-- INVENTORIES VIEW
go
Create --  drop
View vInventoryTable
With Schemabinding
AS
	Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count]
	From dbo.Inventories
go

go
Select * From vInventoryTable
go

-- Question 2 (5 pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

Deny Select On Categories to Public;
Grant Select On vCategoryTable to Public;

Deny Select On Products to Public;
Grant Select On vProductTable to Public;

Deny Select On Employees to Public;
Grant Select On vEmployeeTable to Public;

Deny Select On Inventories to Public;
Grant Select On vInventoryTable to Public;



-- Question 3 (10 pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,UnitPrice
-- Beverages,Chai,18.00
-- Beverages,Chang,19.00
-- Beverages,Chartreuse verte,18.00

go
	Create --  drop
	View vProductsPriceByCategory
	With Schemabinding
AS
	Select TOP 100 Percent
		 c.CategoryName, p.ProductName, p.UnitPrice
	From dbo.Products as p join dbo.Categories as c on p.CategoryID=c.CategoryID
	Order by c.CategoryID, p.ProductID
go
Select * From vProductsPriceByCategory
go


-- Question 4 (10 pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
--ProductName,InventoryDate,Count
--Alice Mutton,2017-01-01,15
--Alice Mutton,2017-02-01,78
--Alice Mutton,2017-03-01,83

go
Create --  drop
View vProductByInventoryDateCount
With Schemabinding
AS
	Select TOP 100 Percent
		p.ProductName, i.InventoryDate, i.[Count]
	From dbo.Products as p
		Join dbo.Inventories as i on i.ProductID=p.ProductID
	Order by p.ProductName, i.InventoryDate, i.[Count];
go

go
Select * From vProductByInventoryDateCount
go

-- Question 5 (10 pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is an example of some rows selected from the view:
-- InventoryDate,EmployeeName
-- 2017-01-01,Steven Buchanan
-- 2017-02-01,Robert King
-- 2017-03-01,Anne Dodsworth

go
Create --  drop
View vInventoryDateByEmployee
With Schemabinding
AS
	Select Distinct TOP 100 Percent
		i.InventoryDate, (e.EmployeeFirstName + ' ' + e.EmployeeLastName) as Employee
	From dbo.Employees as e
		Join dbo.Inventories as i on i.EmployeeID=e.EmployeeID
	Order by i.InventoryDate, Employee;
go

go
Select * From vInventoryDateByEmployee
go

-- Question 6 (10 pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- Beverages,Chai,2017-01-01,72
-- Beverages,Chai,2017-02-01,52
-- Beverages,Chai,2017-03-01,54

go
Create --  drop
View vCategoryProductInventoryDateCount
With Schemabinding
AS
	Select TOP 100 Percent
		c.CategoryName, p.ProductName, i.InventoryDate, i.[Count]
	From dbo.Categories as c 
		Join dbo.Products as p on p.CategoryID=c.CategoryID 
		Join dbo.Inventories as i on i.ProductID=p.ProductID
	Order by c.CategoryID, p.ProductID, i.InventoryDate, i.[Count];
go

go
Select * From vCategoryProductInventoryDateCount
go

-- Question 7 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chartreuse verte,2017-01-01,61,Steven Buchanan

go
Create --  drop
View vCategProductInventDateCountEmp
With Schemabinding
AS
	Select TOP 100 Percent
		c.CategoryName, p.ProductName, i.InventoryDate, i.[Count], (e.EmployeeFirstName + ' ' + e.EmployeeLastName) as Employee
	From dbo.Categories as c 
		Join dbo.Products as p on p.CategoryID=c.CategoryID 
		Join dbo.Inventories as i on i.ProductID=p.ProductID
		Join dbo.Employees as e on e.EmployeeID=i.EmployeeID
	Order by i.InventoryDate, c.CategoryID, p.ProductID, Employee;
go

go
Select * From vCategProductInventDateCountEmp
go

-- Question 8 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chai,2017-02-01,52,Robert King

Create --  drop
View vProdChaiChangDateCountEmp
With Schemabinding
AS
	Select TOP 100 Percent
		c.CategoryName, p.ProductName, i.InventoryDate, i.[Count], (e.EmployeeFirstName + ' ' + e.EmployeeLastName) AS EmployeeName
	From dbo.Categories as c 
		Join dbo.Products as p on c.CategoryID=p.CategoryID
		Join dbo.Inventories as i on i.ProductID=p.ProductID
		Join dbo.Employees as e on e.EmployeeID=i.EmployeeID
	Where p.ProductID in (Select ProductID 
											From dbo.Products 
											Where productname in ('Chai', 'Chang'))
	Order by i.InventoryDate, c.CategoryName,p.ProductName, EmployeeName;
go

go
Select * From vProdChaiChangDateCountEmp
go

-- Question 9 (10 pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here is an example of some rows selected from the view:
-- Manager,Employee
-- Andrew Fuller,Andrew Fuller
-- Andrew Fuller,Janet Leverling
-- Andrew Fuller,Laura Callahan

Create --  drop
View vEmployeeWithManagers
With Schemabinding
AS
	Select TOP 100 Percent
		(e.EmployeeFirstName + ' ' + e.EmployeeLastName) AS Manager, 
		(m.EmployeeFirstName + ' ' + m.EmployeeLastName) AS Employee	
	From dbo.Employees as e 
		Join dbo.Employees as m on e.EmployeeID=m.ManagerID
	Order by Manager, Employee;
go

go
Select * From vEmployeeWithManagers
go


-- Question 10 (10 pts): How can you create one view to show all the data from all four 
-- BASIC Views?

-- Here is an example of some rows selected from the view:
-- CategoryID,CategoryName,ProductID,ProductName,UnitPrice,InventoryID,InventoryDate,Count,EmployeeID,Employee,Manager
-- 1,Beverages,1,Chai,18.00,1,2017-01-01,72,5,Steven Buchanan,Andrew Fuller
-- 1,Beverages,1,Chai,18.00,78,2017-02-01,52,7,Robert King,Steven Buchanan
-- 1,Beverages,1,Chai,18.00,155,2017-03-01,54,9,Anne Dodsworth,Steven Buchanan

Create --  drop
View vCategoryProductInventoryEmployee
With Schemabinding
AS
	Select TOP 100 Percent
			c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.UnitPrice, i.InventoryID, i.InventoryDate, i.[Count], e.EmployeeID,
			(e.EmployeeFirstName + ' ' + e.EmployeeLastName) AS Employee,
			(m.EmployeeFirstName + ' ' + m.EmployeeLastName) AS Manager
		From dbo.vEmployeeTable e 
			Join dbo.vEmployeeTable m on m.EmployeeID=e.ManagerID
			Join dbo.vInventoryTable i on e.EmployeeID=i.EmployeeID
			Join dbo.vProductTable p on p.ProductID=i.ProductID
			Join dbo.vCategoryTable c on c.CategoryID=p.CategoryID
	Order by c.CategoryID, p.ProductID, i.InventoryDate
go

go
Select * From vCategoryProductInventoryEmployee
go

-- Test your Views (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategoryTable]
Select * From [dbo].[vProductTable]
Select * From [dbo].[vInventoryTable]
Select * From [dbo].[vEmployeeTable]

Select * From [dbo].[vProductsPriceByCategory]
Select * From [dbo].[vProductByInventoryDateCount]
Select * From [dbo].[vInventoryDateByEmployee]
Select * From [dbo].[vCategoryProductInventoryDateCount]
Select * From [dbo].[vCategProductInventDateCountEmp]
Select * From [dbo].[vProdChaiChangDateCountEmp]
Select * From [dbo].[vEmployeeWithManagers]
Select * From [dbo].[vCategoryProductInventoryEmployee]
/***************************************************************************************/