 --Database Creation
 
------------------------------------------
create DATABASE RetailDB;                 
USE RetailDB;
------------------------------------------------- 

CREATE TABLE Products (
  ProductID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  ProductName varchar(50) NOT NULL,
  Category varchar(50),
  Price decimal(10,2) NOT NULL,
  StockQuantity int NOT NULL CHECK (StockQuantity >= 0)
);


CREATE TABLE Customers (
  CustomerID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NOT NULL,
  Email varchar(100) UNIQUE,
  Phone varchar(20),
  Address varchar(255),
  CHECK (LEN(FirstName) > 0)  -- Ensures a first name is provided
);

CREATE TABLE Orders (
  OrderID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  CustomerID int NOT NULL,
  OrderDate datetime NOT NULL,
  TotalAmount decimal(10,2) NOT NULL,
  OrderStatus varchar(50) NOT NULL,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
  OrderDetailID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  OrderID int NOT NULL,
  ProductID int NOT NULL,
  Quantity int NOT NULL CHECK (Quantity > 0),
  UnitPrice decimal(10,2) NOT NULL,
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
CREATE TABLE Suppliers (
  SupplierID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
  SupplierName varchar(50) NOT NULL,
  ContactName varchar(50),
  Phone varchar(20),
  Email varchar(100) UNIQUE
);
----------------------------------------------------
 --Data Insertion
 select*from Products;
----------------------------------------------------  
DECLARE @i INT = 0;

WHILE @i < 1000
BEGIN
    INSERT INTO Products (ProductID, ProductName, Category, Price, StockQuantity)
    VALUES (
        ABS(CHECKSUM(NEWID())) % 1000000, -- Random ProductID
        'Product_' + LEFT(NEWID(), 8), -- Random product name
        'Category_' + LEFT(NEWID(), 8), -- Random category name
        ROUND(RAND(CHECKSUM(NEWID())) * 1000, 2), -- Random price between 0 and 1000
        ABS(CHECKSUM(NEWID())) % 1000 -- Random stock quantity between 0 and 999
    );
    SET @i = @i + 1;
END;

-- Enable IDENTITY_INSERT
SET IDENTITY_INSERT Products ON;

-- Turn off IDENTTIY_INSERT for Products table if it's still on
SET IDENTITY_INSERT Products OFF;

--------------------------------------------------------------------
-- Insert random data into the Customers table

SET IDENTITY_INSERT Customers OFF;
DECLARE @c INT = 0;
DECLARE @FirstName VARCHAR(50);
DECLARE @LastName VARCHAR(50);
DECLARE @Phone VARCHAR(20);
DECLARE @Email VARCHAR(100);
DECLARE @Address VARCHAR(255);
DECLARE @CustomerID INT;


-- Predefined lists of first names and last names
DECLARE @FirstNames TABLE (Name VARCHAR(50));
DECLARE @LastNames TABLE (Name VARCHAR(50));

-- Insert some sample first names and last names into the tables
INSERT INTO @FirstNames (Name) VALUES ('John'), ('Jane'), ('Alice'), ('Bob'), ('Charlie'), ('David'), ('Emily'), ('Frank'), ('Grace'), ('Hank');
INSERT INTO @LastNames (Name) VALUES ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones'), ('Miller'), ('Davis'), ('Garcia'), ('Rodriguez'), ('Martinez');

WHILE @c < 1000
BEGIN
	SET @CustomerID = ABS(CHECKSUM(NEWID())) % 1000 + 1;

    -- Generate random FirstName
    SELECT TOP 1 @FirstName = Name FROM @FirstNames ORDER BY NEWID();

    -- Generate random LastName
    SELECT TOP 1 @LastName = Name FROM @LastNames ORDER BY NEWID();

    -- Generate random Phone number
    SET @Phone = '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR), 4);

    -- Generate random Email
    SET @Email = LOWER(@FirstName + '.' + @LastName + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR) + '@example.com');

    -- Generate random Address
    SET @Address = CAST(ABS(CHECKSUM(NEWID())) % 9999 AS VARCHAR) + ' ' + 
                   CASE ABS(CHECKSUM(NEWID())) % 5
                       WHEN 0 THEN 'Elm St.'
                       WHEN 1 THEN 'Oak Ave.'
                       WHEN 2 THEN 'Pine Rd.'
                       WHEN 3 THEN 'Maple Dr.'
                       WHEN 4 THEN 'Cedar Blvd.'
                   END;

    -- Insert the random data into the Customers table
    INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
    VALUES (@FirstName, @LastName, @Email, @Phone, @Address);

    SET @c = @c + 1;
END;

-----------------------------------------------------------------
DECLARE @o INT = 0;
DECLARE @CustomerID INT;
DECLARE @OrderDate DATETIME;
DECLARE @TotalAmount DECIMAL(10,2);
DECLARE @OrderStatus VARCHAR(50);

WHILE @o < 1000
BEGIN
    -- Get a random CustomerID from the Customers table
    SELECT TOP 1 @CustomerID = CustomerID 
    FROM Customers 
    ORDER BY NEWID();

    -- Generate random OrderDate between 1 year ago and now
    SET @OrderDate = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE());

    -- Generate random TotalAmount between 0 and 1000
    SET @TotalAmount = ROUND(RAND(CHECKSUM(NEWID())) * 10000, 2);

    -- Randomly select an OrderStatus
    SET @OrderStatus = CASE ABS(CHECKSUM(NEWID())) % 5
                       WHEN 0 THEN 'Pending'
                       WHEN 1 THEN 'Processing'
                       WHEN 2 THEN 'Shipped'
                       WHEN 3 THEN 'Delivered'
                       ELSE 'Cancelled'
                       END;

    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus)
    VALUES (@CustomerID, @OrderDate, @TotalAmount, @OrderStatus);

    SET @o = @o + 1;
END;
---------------------------------------------------------------------------------
DECLARE @od INT = 0;
DECLARE @OrderID INT;
DECLARE @ProductID INT;
DECLARE @Quantity INT;
DECLARE @UnitPrice DECIMAL(10,2);

WHILE @od < 1000
BEGIN
    -- Get a random OrderID from the Orders table
    SELECT TOP 1 @OrderID = OrderID 
    FROM Orders 
    ORDER BY NEWID();

    -- Get a random ProductID from the Products table
    SELECT TOP 1 @ProductID = ProductID 
    FROM Products 
    ORDER BY NEWID();

    -- Generate random Quantity between 1 and 10
    SET @Quantity = ABS(CHECKSUM(NEWID())) % 10 + 1;

    -- Get the UnitPrice for the selected ProductID
    SELECT @UnitPrice = Price 
    FROM Products 
    WHERE ProductID = @ProductID;

    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice);

    SET @od = @od + 1;
END;


-- Insert random data into the Suppliers table
DECLARE @s INT = 0;
DECLARE @SupplierName VARCHAR(50);
DECLARE @ContactName VARCHAR(50);
DECLARE @Phone VARCHAR(20);
DECLARE @Email VARCHAR(100);

WHILE @s < 10000
BEGIN
    -- Generate random SupplierName
    SET @SupplierName = 'Supplier' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR);

    -- Generate random ContactName
    SET @ContactName = 'Contact' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR);

    -- Generate random Phone number
    SET @Phone = '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR), 4);

    -- Generate random Email
    SET @Email = 'supplier' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR) + '@example.com';

    -- Insert the random data into the Suppliers table
    INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email)
    VALUES (@SupplierName, @ContactName, @Phone, @Email);

    SET @s = @s + 1;
END;

------------------------------------------------------------

-------------------------------------------------------------
 --CRUD Operations
 --Scripts for inserting, updating, deleting, and selecting records from each table
-------------------------------------------------------------

INSERT INTO Products (ProductID,ProductName, Category, Price, StockQuantity)
VALUES 
(11,'Product1', 'Category1', 19.99, 100),
(12,'Product2', 'Category2', 29.99, 150),
(13,'Product3', 'Category3', 39.99, 200);

UPDATE Products
SET ProductName = 'Product_clo', Category= 'Category_zy'
WHERE ProductID = 11;


delete from Products
where ProductID in (11,12,13);

select *
from Products

select distinct Category,ProductID
from Products
------------------------------------------------------------------------------
----------------------------------------------------------------------------
INSERT INTO Customers (CustomerID,FirstName, LastName, Email, Phone, Address)
VALUES 
(15,'Jorge', 'Doe', 'john.doe@example.com', '555-1234', '123 Elm Street'),
(24,'James', 'Smith', 'jane.smith@example.com', '555-5678', '456 Oak Avenue'),
(36,'Alicent', 'Johnson', 'alice.johnson@example.com', '555-9876', '789 Pine Road');

UPDATE Customers
SET Phone = '966-1525', Address= '25 youssif Street'
WHERE CustomerID = 24;

delete from Customers
where CustomerID = 36;

select *
from Customers

select FirstName +' '+ LastName as fullname,
CustomerID
from Customers
--------------------------------------------------------------------------
-------------------------------------------------------------------------
insert into Orders (OrderID,CustomerID,OrderDate,TotalAmount,OrderStatus)
VALUES 
(152,15, '2024-07-10', 99.99, 'Pending'),
(153,24, '2024-07-11', 149.99, 'Shipped'),
(154,36, '2024-07-12', 199.99, 'Delivered');

UPDATE Orders
SET OrderDate = '2024-07-15', OrderStatus= 'Delivered'
WHERE OrderID = 152;

delete from Orders
where CustomerID in (36);

select *
from Orders

select OrderDate,OrderStatus,OrderID,CustomerID
from Orders
-------------------------------------------------------------------
-------------------------------------------------------------------
INSERT INTO OrderDetails (OrderDetailID,OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(180,152, 11, 2, 19.99),
(201,153, 12, 1, 29.99),
(451,154, 13, 3, 39.99);

UPDATE OrderDetails
SET Quantity = '10', UnitPrice= '300.25'
WHERE OrderDetailID = 180;


delete from OrderDetails
where ProductID in (11,12,13);

SELECT ProductID, SUM(UnitPrice) AS TotalUnitPrice
FROM OrderDetails
GROUP BY ProductID;

------------------------------------------------------------------
------------------------------------------------------------------
INSERT INTO Suppliers (SupplierID,SupplierName,ContactName, Email,Phone)
VALUES 
(80,'Supplier1', 'Contact1', 'contact1@supplier.com', '555-1111'),
(11,'Supplier2', 'Contact2', 'contact88@supplier.com', '555-2222'),
(22,'Supplier3', 'Contact3', 'contact3@supplier.com', '555-3333');



UPDATE Suppliers
SET Phone= '104-6568', Email= 'supplier174@yahoo.com'
WHERE SupplierID = 80;



delete from Suppliers
where SupplierName ='Supplier1';


select SupplierID ,SupplierName,Phone
from Suppliers
--------------------------------------------------------------------------
--Advanced Queries
--------------------------------------------------------------------------
--Inner join
SELECT 
    O.OrderID,
    C.CustomerID,
    C.FirstName,
    C.LastName,
    P.ProductID,
    P.ProductName,
    OD.Quantity,
    OD.UnitPrice,
    O.OrderDate,
    O.TotalAmount,
    O.OrderStatus
FROM 
    Orders O
INNER JOIN 
    Customers C ON O.CustomerID = C.CustomerID
INNER JOIN 
    OrderDetails OD ON O.OrderID = OD.OrderID
INNER JOIN 
    Products P ON OD.ProductID = P.ProductID
ORDER BY 
    O.OrderID;
---------------------------------------------------------
--left join
SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.StockQuantity,
       s.SupplierID, s.SupplierName, s.ContactName, s.Phone, s.Email
FROM Products p
LEFT JOIN Suppliers s ON p.ProductID = s.SupplierID;
------------------------------------------------------------
--right join

SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.StockQuantity,
       s.SupplierID, s.SupplierName, s.ContactName, s.Phone, s.Email
FROM Suppliers s
RIGHT JOIN Products p ON s.SupplierID = p.ProductID;
----------------------------------------------------------
--outer join

SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone, c.Address,
       o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

-----------------------------------------------------------
--Subquerys
-----------------------------------------------------------
SELECT 
    C.CustomerID,
    C.FirstName,
    C.LastName,
    CustomerOrderCount.OrderCount
FROM 
    Customers C
INNER JOIN (
    -- Subquery to count the number of orders each customer has placed
    SELECT 
        CustomerID,
        COUNT(OrderID) AS OrderCount
  FROM 
  
  Orders
 GROUP BY 
   CustomerID
) AS CustomerOrderCount ON C.CustomerID = CustomerOrderCount.CustomerID
WHERE 
    CustomerOrderCount.OrderCount = (
        -- Subquery to find the maximum number of orders placed by any customer
 SELECT 
  MAX(OrderCount)
    FROM (										-- Subquery to count the number of orders each customer has placed
    SELECT 
      CustomerID,
  COUNT(OrderID) AS OrderCount
  FROM 
  Orders
 GROUP BY 
CustomerID
) AS OrderCounts
);
------------------------------------------------------------
--Cte
------------------------------------------------------------
WITH OrderSummary AS (
    SELECT 
        o.OrderID,
        o.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        o.OrderDate,
        o.TotalAmount,
        o.OrderStatus,
        od.ProductID,
        od.Quantity,
        od.UnitPrice,
        p.ProductName,
        p.Category
    FROM 
        Orders o
    JOIN 
        OrderDetails od ON o.OrderID = od.OrderID
    JOIN 
        Customers c ON o.CustomerID = c.CustomerID
    JOIN 
        Products p ON od.ProductID = p.ProductID
)
-- Query to select from the CTE
SELECT 
    OrderID,
    CustomerID,
    CustomerName,
    OrderDate,
    TotalAmount,
    OrderStatus,
    ProductID,
    ProductName,
    Category,
    Quantity,
    UnitPrice
FROM 
    OrderSummary;
----------------------------------------------------------
--Window Functions
----------------------------------------------------------
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(od.Quantity) AS TotalSales,
    RANK() OVER (ORDER BY SUM(od.Quantity) DESC) AS SalesRank
FROM
    OrderDetails od
JOIN
    Products p ON od.ProductID = p.ProductID
GROUP BY
    p.ProductID, p.ProductName, p.Category
ORDER BY
    SalesRank;
----------------------------------------------------
-- Views
----------------------------------------------------

GO
-- Create the view in a separate batch
CREATE VIEW Active_orders AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.Phone,
    c.Address
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    o.OrderStatus IN ('Pending', 'Processing', 'Shipped');
GO

--- use view
SELECT * FROM Active_orders;


--------------------------------------------------
go
CREATE VIEW Productorderdetails AS

SELECT
    P.ProductID,
    P.ProductName,
    P.Category,
    P.Price,
    P.StockQuantity,
    OD.OrderDetailID,
    OD.OrderID,
    OD.Quantity,
    OD.UnitPrice
FROM 
    Products P
FULL OUTER JOIN 
    OrderDetails OD ON P.ProductID = OD.ProductID;
go
--- use view
select* from Productorderdetails
-----------------------------------------------------------------
-- Stock  PROCEDURE 
--Update_Stock_Quantity
-----------------------------------------------------------------
go
CREATE PROCEDURE UpdateStockQuantity
   @ProductID INT,
    @Quantity INT
AS
BEGIN
   SET NOCOUNT ON;

     -- Check if the product exists
    IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
    BEGIN
        -- Update the stock quantity
        UPDATE Products
        SET StockQuantity = @Quantity
        WHERE ProductID = @ProductID;

        PRINT 'Stock quantity updated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Product not found.';
    END
END

EXEC UpdateStockQuantity @ProductID = 5360, @Quantity = 220;

----------------------------------------------------------
-- Stock PROCEDURE 
--Monthly_Sales_Report
--------------------------------------------------------
go
CREATE PROCEDURE GenerateMonthlySalesReport
    @Year int,
    @Month int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.Category,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM 
        Orders o
        INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
        INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE 
        YEAR(o.OrderDate) = @Year
        AND MONTH(o.OrderDate) = @Month
    GROUP BY 
        p.Category
    ORDER BY 
        TotalSales DESC;
END;

EXEC GenerateMonthlySalesReport @Year = 2024, @Month = 7;

--2023 range between 7 to 12
--2024 range between 1 to 7
---------------------------------------------------------------------------

--------------------------------------------------------------------------
			