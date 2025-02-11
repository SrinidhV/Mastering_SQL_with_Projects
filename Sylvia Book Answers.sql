-- Start Of Introductory Problems --

-- 1) 
USE northwindmysql;
SELECT * FROM shippers;

-- 2)
SELECT categoryname,description FROM categories;

-- 4)
SELECT FirstName, LastName, HireDate
FROM employees
WHERE title='Sales Representative' and country ='USA'

-- 5)
SELECT o.OrderID, o.OrderDate 
FROM orders o JOIN employees e ON
o.EmployeeID = e.EmployeeID
WHERE o.EmployeeID = 5

-- 6)
SELECT SupplierID,ContactName,ContactTitle
FROM suppliers 
WHERE NOT ContactTitle = 'Marketing Manager'

-- 7)
SELECT ProductID,ProductName 
FROM products
WHERE ProductName LIKE '%queso%'

-- 8)
SELECT OrderID, CustomerID, ShipCountry
FROM orders 
WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium'

-- 9)
SELECT OrderID, CustomerID, ShipCountry
FROM orders 
WHERE ShipCountry IN ('brazil', 'mexico', 'argentina', 'venezuela')

-- 10)
SELECT FirstName, LastName, Title, BirthDate
FROM employees
ORDER BY BirthDate

-- 11)
SELECT FirstName, LastName, Title, CAST(BirthDate AS DATE)
FROM employees
ORDER BY BirthDate

-- 12)
SELECT FirstName, LastName , CONCAT(FirstName ,' ',LastName) as FullName
FROM employees

-- 13)
SELECT  OrderID, ProductID, UnitPrice,Quantity, UnitPrice * Quantity AS TotalSales
FROM orderdetails
ORDER BY OrderID, ProductID

-- 14)
SELECT COUNT(*) AS NumberOfCustomers
FROM customers

-- 15)
SELECT MIN(OrderDate) as FirstOrder
from orders

-- 16)
SELECT  DISTINCT country
FROM customers

-- 17)
SELECT ContactTitle, COUNT(*) as NumOfCustomers
FROM customers
GROUP BY ContactTitle
ORDER BY COUNT(*) DESC

-- 18)
SELECT p.ProductID, p.ProductName, s.CompanyName
FROM products p JOIN suppliers s ON p.supplierID = s.supplierID
ORDER BY ProductID

-- 19)
SELECT o.OrderID, CAST(o.OrderDate AS DATE) as OrderDate , s.CompanyName
FROM orders o JOIN shippers s ON o.ShipVia = s.ShipperID
WHERE OrderID < 10300
ORDER BY OrderID

-- END OF INTRODUCTORY PROBLEMS --

-- Start Of Intermediate Problems ---

-- 20)
SELECT c.CategoryName , COUNT(p.ProductID) as TotalProducts
FROM categories c JOIN products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY 2 DESC

-- 21)
SELECT Country, City, COUNT(*) as TotalCustomers
FROM customers 
GROUP BY Country,City
ORDER BY 3 DESC;


-- 22)
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM products
WHERE UnitsInStock < ReorderLevel
ORDER BY ProductID;

-- 23)
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM products
WHERE (UnitsInStock + UnitsOnOrder <= ReorderLevel) and Discontinued = 0
ORDER BY ProductID;

-- 24)
SELECT CustomerID, CompanyName, Region
FROM customers
ORDER BY 
CASE 
WHEN Region IS NULL THEN 1
ELSE 0
END ASC,
Region ASC;

-- 25)
SELECT ShipCountry, AVG(Freight) as AverageFreight
FROM orders
GROUP BY ShipCountry
ORDER BY 2 DESC
LIMIT 3;

-- 26)
SELECT ShipCountry, AVG(Freight) as AverageFreight
FROM orders
WHERE EXTRACT(YEAR FROM OrderDate) = 2015
GROUP BY ShipCountry
ORDER BY 2 DESC
LIMIT 3;

-- 28)
SELECT ShipCountry, AVG(Freight) as AverageFreight
FROM orders
WHERE OrderDate BETWEEN (SELECT MAX(OrderDate) - INTERVAL 12 MONTH FROM orders) AND (SELECT MAX(OrderDate) FROM orders)
GROUP BY ShipCountry

ORDER BY 2 DESC
LIMIT 3;

-- 29)
SELECT e.EmployeeID ,e.LastName, o.OrderID, p.ProductName, od.Quantity
FROM employees e 
JOIN orders o ON e.employeeID = o.employeeID
JOIN orderdetails od ON od.orderID = o.orderID
JOIN products p ON p.productID = od.productID
ORDER BY o.OrderID , p.ProductID;

-- 30)
SELECT
  Customers.CustomerID AS Customers_CustomerID,
  Orders.CustomerID AS Orders_CustomerID
FROM 
  Customers
  LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID
WHERE NOT EXISTS( SELECT O.CustomerID FROM orders O WHERE Customers.CustomerID = o.CustomerID);

-- 31)
WITH cte AS(SELECT CONCAT(e.FirstName, ' ', e.LastName) as Employee, COUNT(o.OrderID) as Total_orders, o.CustomerID
FROM employees e  JOIN orders o ON e.EmployeeID = o.EmployeeID 
WHERE FirstName = 'Margaret' AND LastName = 'Peacock'
GROUP BY Employee,o.CustomerID
ORDER BY 2 DESC)

SELECT cte.CustomerID, c.CustomerID
FROM customers c LEFT JOIN cte ON cte.CustomerID = c.CustomerID
WHERE cte.CustomerID IS NULL
ORDER BY 2;

-- -- -- -----------------------------

WITH cte AS (SELECT o.CustomerID
FROM employees e JOIN orders o ON e.EmployeeID  = o.EmployeeID
WHERE FirstName = 'Margaret' AND LastName = 'Peacock')

Select cte.CustomerID , c.CustomerID
FROM customers c LEFT JOIN cte ON c.CustomerID = cte.CustomerID
WHERE cte.CustomerID IS NULL;

-- ------------------------------------
Select
Customers.CustomerID
,Orders.CustomerID
From Customers
left join Orders
on Orders.CustomerID = Customers.CustomerID and Orders.EmployeeID = 4
Where
Orders.CustomerID is null;

-- 32)

SELECT c.CustomerID, c.CompanyName, o.OrderID, SUM(od.Quantity * od.UnitPrice) as TotalPrice
FROM customers c JOIN orders o ON c.CustomerID = o. CustomerID 
JOIN orderdetails od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 2016
GROUP BY 1,2,3
HAVING COUNT(*) >=1 and TotalPrice >= 10000;

-- 33)

SELECT c.CustomerID, c.CompanyName, SUM(od.Quantity * od.UnitPrice) as TotalPrice
FROM customers c JOIN orders o ON c.CustomerID = o. CustomerID 
JOIN orderdetails od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 2016
GROUP BY 1,2
HAVING TotalPrice >= 15000
ORDER BY TotalPrice DESC;

-- 34)
SELECT c.CustomerID, c.CompanyName, SUM(od.Quantity * od.UnitPrice) as TotalPriceWithoutDisc,
SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) as TotalPriceWithDiscount
FROM customers c JOIN orders o ON c.CustomerID = o. CustomerID 
JOIN orderdetails od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 2016
GROUP BY 1,2
HAVING TotalPriceWithoutDisc >= 15000
ORDER BY TotalPriceWithoutDisc DESC;

-- 35)
SELECT EmployeeID, OrderID, DATE(OrderDate) as OrderDate
FROM orders
WHERE DATE(OrderDate) = LAST_DAY(OrderDate)
ORDER BY 1,2;

-- 36) Finding most orders with line items
SELECT OrderID, COUNT(*) as TotalOrderDetails
FROM orderdetails
GROUP BY OrderID
ORDER BY TotalOrderDetails DESC
LIMIT 10;

-- 37)

SELECT OrderID 
FROM orders
WHERE rand()<= 0.02;

-- 38)
SELECT od.OrderID
FROM orderdetails od 
WHERE  od.Quantity >= 60
GROUP BY od.OrderID,od.quantity
HAVING COUNT(*) > 1;

-- 39)
WITH cte AS
(SELECT od.OrderID
FROM orderdetails od 
WHERE  od.Quantity >= 60
GROUP BY od.OrderID,od.quantity
HAVING COUNT(DISTINCT od.ProductID) > 1)

SELECT DISTINCT c.OrderID, od.ProductID, od.UnitPrice, od.Quantity, od.Discount
FROM orderdetails od JOIN cte c ON c.OrderID = od.OrderID;


-- 40) --- Using SELF JOIN -------

SELECT orderdetails.OrderID, ProductID, UnitPrice, Quantity, Discount
FROM orderdetails 
JOIN( 
SELECT OrderID
FROM orderdetails
WHERE quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(*) > 1) subq
ON subq.OrderID = orderdetails.OrderID
GROUP BY 1,2;

-- 41) Late Orders
SELECT OrderID, OrderDate, RequiredDate, ShippedDate
FROM orders
WHERE ShippedDate >= RequiredDate
ORDER BY 1;

-- 42)

SELECT o.EmployeeID, e.LastName, COUNT(*) as TotalLateOrders
FROM  employees e
JOIN orders o ON o.EmployeeID = e.EmployeeID
WHERE ShippedDate >= RequiredDate
GROUP BY 1,2;

-- 43)
WITH cte AS (
SELECT o.EmployeeID, e.LastName, COUNT(*) as TotalLateOrders
FROM  employees e
JOIN orders o ON o.EmployeeID = e.EmployeeID
WHERE ShippedDate >= RequiredDate
GROUP BY 1,2)

SELECT o.EmployeeID , c.LastName, COUNT(*) AS TotalOrders, c.TotalLateOrders
FROM orders o JOIN cte c ON o.EmployeeID = c.EmployeeID
GROUP BY 1,2,4;


-- 44) , 45)

WITH cte1 AS (SELECT EmployeeId, COUNT(*) as totalLateOrders
FROM orders
WHERE ShippedDate >= RequiredDate
GROUP BY 1)

, cte2 AS (
SELECT EmployeeID, COUNT(*) as TotalOrders
FROM orders
GROUP BY 1
)

SELECT e.EmployeeID, COALESCE(cte1.totalLateOrders,0) AS TotalLateOrders, COALESCE(cte2.TotalOrders,0) as TotalOrders
FROM Employees e LEFT JOIN cte1 ON cte1.EmployeeID = e.EmployeeID
LEFT JOIN cte2 ON cte2.EmployeeID = e.EmployeeID
ORDER BY 3

-- 46)

WITH cte1 AS (SELECT EmployeeId, COUNT(*) as totalLateOrders
FROM orders
WHERE ShippedDate >= RequiredDate
GROUP BY 1)

, cte2 AS (
SELECT EmployeeID, COUNT(*) as TotalOrders
FROM orders
GROUP BY 1
)

SELECT e.EmployeeID, 
COALESCE(cte1.totalLateOrders,0) AS TotalLateOrders, 
COALESCE(cte2.TotalOrders,0) as TotalOrders,
(COALESCE(cte1.totalLateOrders,0) / NULLIF(COALESCE(cte2.TotalOrders,0),0)) * 100 AS PercentLateOrders
FROM Employees e LEFT JOIN cte1 ON cte1.EmployeeID = e.EmployeeID
LEFT JOIN cte2 ON cte2.EmployeeID = e.EmployeeID
ORDER BY 3 DESC


-- 47)
WITH cte1 AS (SELECT EmployeeId, COUNT(*) as totalLateOrders
FROM orders
WHERE ShippedDate >= RequiredDate
GROUP BY 1)

, cte2 AS (
SELECT EmployeeID, COUNT(*) as TotalOrders
FROM orders
GROUP BY 1
)

SELECT e.EmployeeID, 
COALESCE(cte1.totalLateOrders,0) AS TotalLateOrders, 
COALESCE(cte2.TotalOrders,0) as TotalOrders,
ROUND((COALESCE(cte1.totalLateOrders,0) / NULLIF(COALESCE(cte2.TotalOrders,0),0)) * 100,2) AS PercentLateOrders
FROM Employees e LEFT JOIN cte1 ON cte1.EmployeeID = e.EmployeeID
LEFT JOIN cte2 ON cte2.EmployeeID = e.EmployeeID
ORDER BY 3 DESC

-- 48) ,49) (Use Comparision Operators instead of 'BETWEEN')
WITH cte AS (SELECT
c.CustomerID, 
c.CompanyName, 
SUM(od.UnitPrice * od.Quantity) AS TotalOrderAmount
FROM customers c
JOIN orders o on C.CustomerID = o.CustomerID
JOIN orderdetails od ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY 1,2

ORDER BY 3 DESC)

SELECT cte.CustomerID , cte.CompanyName, cte.TotalOrderAmount,
CASE
WHEN cte.TotalOrderAmount >= 0 AND cte.TotalOrderAmount < 1000 THEN 'Low'
WHEN cte.TotalOrderAmount >= 1000 AND cte.TotalOrderAmount <5000 THEN 'Medium'
WHEN cte.TotalOrderAmount >= 5000 AND cte.TotalOrderAmount <10000 THEN 'High'
ELSE 'Very High'
END
AS CustomerGroup
FROM cte

ORDER BY CustomerGroup


-- 50)

WITH cte AS (SELECT
c.CustomerID, 
c.CompanyName, 
SUM(od.UnitPrice * od.Quantity) AS TotalOrderAmount
FROM customers c
JOIN orders o on C.CustomerID = o.CustomerID
JOIN orderdetails od ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY 1,2

ORDER BY 3 DESC),

cte2 AS (SELECT 
CASE
WHEN cte.TotalOrderAmount >= 0 AND cte.TotalOrderAmount < 1000 THEN 'Low'
WHEN cte.TotalOrderAmount >= 1000 AND cte.TotalOrderAmount <5000 THEN 'Medium'
WHEN cte.TotalOrderAmount >= 5000 AND cte.TotalOrderAmount <10000 THEN 'High'
ELSE 'Very High'
END AS CustomerGroup
FROM cte
ORDER BY CustomerGroup
)
SELECT 
    cte2.CustomerGroup, 
    COUNT(*) AS Each_Count,
    SUM(COUNT(*)) OVER () AS Total_Count,( COUNT(*) / (SELECT COUNT(*) FROM cte2)) *100 AS Percentcount
FROM cte2
GROUP BY cte2.CustomerGroup
ORDER BY PercentCount;

-- 51)

WITH cte AS (SELECT
c.CustomerID, 
c.CompanyName, 
SUM(od.UnitPrice * od.Quantity) AS TotalOrderAmount
FROM customers c
JOIN orders o on C.CustomerID = o.CustomerID
JOIN orderdetails od ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY 1,2

ORDER BY 3 DESC)

SELECT cte.CustomerID , cte.CompanyName, cte.TotalOrderAmount, cgt.CustomerGroupName
FROM cte 
JOIN customergroupthresholds cgt ON cte.TotalOrderAmount >= cgt.RangeBottom AND cte.TotalOrderAmount <= cgt.RangeTop
ORDER BY CustomerID;

-- 52)
SELECT Country
FROM customers
UNION
SELECT Country
FROM suppliers
ORDER BY 1;

-- 53)
 
SELECT s.Country,c.Country
FROM customers c LEFT JOIN suppliers s ON c.Country = s.Country
UNION
SELECT s.Country,c.Country
FROM customers c RIGHT JOIN suppliers s ON c.Country = s.Country
ORDER BY 1;

-- 54)
WITH cte AS (SELECT Country, COUNT(*) as TotalSuppliers
FROM suppliers
GROUP BY Country)

, cte2 AS( 
SELECT Country, COUNT(*) AS TotalCustomers FROM customers
GROUP BY Country)

SELECT COALESCE(cte.Country,cte2.Country) as Country , cte.TotalSuppliers, cte2.TotalCustomers
FROM cte2  JOIN cte ON cte.Country = cte2.Country;
-- ---------------------

WITH cte AS (
    SELECT Country, COUNT(*) as TotalSuppliers
    FROM suppliers
    GROUP BY COUNTRY
),
cte2 AS (
    SELECT Country, COUNT(*) AS TotalCustomers
    FROM customers
    GROUP BY Country
)
SELECT
    cte2.Country as Country,
    cte.TotalSuppliers,
    cte2.TotalCustomers
FROM cte2
LEFT JOIN cte ON cte.Country = cte2.Country  -- LEFT JOIN to get all from Customers (cte2) and matching Suppliers (cte)
UNION   -- Combine results, including unmatched rows from both sides
SELECT
    cte.Country as Country,
    cte.TotalSuppliers,
    cte2.TotalCustomers
FROM cte
LEFT JOIN cte2 ON cte2.Country = cte.Country;  -- LEFT JOIN to get all from Suppliers (cte) and matching Customers (cte2)
; -- Important: Filter to only include Suppliers countries that were NOT already included in the LEFT JOIN part

-- ----- the above question could be done by using a FULL OUTER JOIN instead of 2 joins with union
-- ----------------------------------------------------------------------------------------------------------

-- 55)
SELECT o.ShipCountry, o.CustomerID, o.OrderID, o.OrderDate
FROM orders o
JOIN
(SELECT ShipCountry, MIN(orderDate) as OrderDate
FROM orders 
GROUP BY ShipCountry) AS oo ON o.ShipCountry = oo.ShipCountry and o.OrderDate = oo.OrderDate
ORDER BY 1;

-- ---
SELECT ShipCountry, CustomerID, orderID, OrderDate
FROM(
SELECT ShipCountry, CustomerID, orderID, OrderDate, 
ROW_NUMBER() OVER( PARTITION BY ShipCountry ORDER BY OrderDate) as rn
FROM orders ) as sq
WHERE sq.rn =1;

-- 56)
SELECT
    o1.CustomerID,
    o1.OrderID AS InitialOrderID,
    DATE(o1.OrderDate) AS InitialOrderDate, -- DATE() function for date conversion in MySQL
    o2.OrderID AS NextOrderID,
    DATE(o2.OrderDate) AS NextOrderDate, -- DATE() function for date conversion in MySQL
    DATEDIFF(DATE(o2.OrderDate), DATE(o1.OrderDate)) AS DaysBetween -- DATEDIFF for days
FROM Orders o1
JOIN Orders o2 ON o1.CustomerID = o2.CustomerID
WHERE
    o1.OrderID < o2.OrderID  -- Added OrderID ordering condition
    AND DATE(O2.OrderDate) <= DATE_ADD(DATE(O1.OrderDate), INTERVAL 5 DAY) -- DATEDIFF for days, and date conversion
ORDER BY
   
o1.CustomerID, o1.OrderID;

-- 56)
SELECT
    o.CustomerID,
    o.OrderID AS InitialOrderID,
    DATE(o.OrderDate) AS InitialOrderDate,
    oo.OrderID as NextOrderID,
    DATE(oo.OrderDate) as NextOrderDate,
    TIMESTAMPDIFF(DAY,DATE(o.OrderDate),DATE(oo.OrderDate)) as DaysBetween
FROM orders o JOIN orders oo ON o.CustomerID = oo.CustomerID 
WHERE datediff( oo.OrderDate, o.OrderDate) <= 5 AND datediff( oo.OrderDate, o.OrderDate) >0
ORDER BY 1,2;


with cte AS(SELECT CustomerID, OrderID, DATE(OrderDate) as InitialDate,
 LEAD(DATE(OrderDate),1) OVER( PARTITION BY CustomerID ORDER BY CustomerID,DATE(OrderDate) ASC) as lagged
 FROM orders
 )
 

 SELECT cte.CustomerID,cte.OrderID,cte.InitialDate,cte.lagged, DATEDIFF(cte.lagged,cte.InitialDate) AS DaysBetween
 FROM cte
 WHERE DATEDIFF(cte.lagged , cte.InitialDate) <=5
 
 


