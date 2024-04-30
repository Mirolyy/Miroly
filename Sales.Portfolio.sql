--SalesOrderDetail--
--The highest amount of ordered products per 1 order, with minimum value of 10000--

SELECT 
	   SalesOrderID,
	   TotalOrderedQty,
	   TotalSumOfOrder
FROM
(
	SELECT Sales.Detail.SalesOrderID,
		   SUM(Sales.Detail.OrderQty) AS TotalOrderedQty,
		   MAX(Sales.Header.SubTotal) AS TotalSumOfOrder
	FROM Sales.Header
	JOIN Sales.Detail
		ON Sales.Header.SalesOrderID = Sales.Detail.SalesOrderID
	WHERE Sales.Header.SubTotal > 10000
	GROUP BY Sales.Detail.SalesOrderID
)X
ORDER BY TotalOrderedQty DESC, TotalSumOfOrder DESC


--Average amount of orders per Month and per Year--


SELECT YEAR(Sales.Header.OrderDate) AS 'Year',
	   MONTH(Sales.Header.OrderDate) AS 'Month',
	   AVG(sales.Header.TaxAmt) AS AvgOrderAmount
FROM   Sales.Header
GROUP BY YEAR(Sales.Header.OrderDate), MONTH(Sales.Header.OrderDate)
ORDER BY YEAR(Sales.Header.OrderDate), MONTH(Sales.Header.OrderDate)

 
 --Same Output as above but in a subquery


SELECT Year,
	   Month,
	   AvgOrderAmount
FROM
(
	SELECT YEAR(Sales.Header.OrderDate) AS 'Year',
		   MONTH(Sales.Header.OrderDate) AS 'Month',
		   AVG(sales.Header.TaxAmt) AS AvgOrderAmount
	FROM Sales.Header
	GROUP BY YEAR(Sales.Header.OrderDate), MONTH(Sales.Header.OrderDate)
)XX
ORDER BY Year , Month 


--Which Order had the highest amount of Tax in January 2012?


SELECT SalesOrderID,
	   Year,
	   Month,
	   TaxAmt
FROM
(
SELECT Sales.Header.SalesOrderID,
	   YEAR(Sales.Header.OrderDate) AS 'Year',
	   MONTH(Sales.Header.OrderDate) AS 'Month',
	   sales.Header.TaxAmt,
	   TOP1 = DENSE_RANK() OVER(PARTITION BY YEAR(Sales.Header.OrderDate), MONTH(Sales.Header.OrderDate) ORDER BY sales.Header.TaxAmt DESC)
FROM Sales.Header
)X
WHERE TOP1 = 1 AND Year = 2012 AND Month = 1


--SalesOrderID with Quantity and Freight between 1000 and 7500--


SELECT Sales.Header.SalesOrderID,
	   Sales.Header.Freight,
	   Sales.Detail.OrderQty
FROM Sales.Header
JOIN Sales.Detail
	ON Sales.Detail.SalesOrderID = Sales.Header.SalesOrderID
WHERE Sales.Header.Freight BETWEEN 1000 AND 7500


--Average Price per TeritoryID--

SELECT AvgPricePerCategory = AVG(Sales.Header.SubTotal) OVER(PARTITION BY Sales.Header.TerritoryID),
	   Sales.Header.TerritoryID
FROM Sales.Header


--Inserting a text into cell--


SELECT 'Ordered: ' + CAST(Sales.Header.OrderDate as varchar(100)) AS DateOfOrder
from Sales.Header


--Total amount of orders per cutsomer--


SELECT Sales.Header.CustomerID,
	   SUM(sales.header.SubTotal) AS TotalOrderAmount
FROM Sales.Header
GROUP BY Sales.Header.CustomerID
ORDER BY SUM(sales.header.subtotal) DESC


--Show orders which has not been sent yet--

SELECT *
FROM Sales.Header
WHERE Sales.Header.ShipDate IS NULL

--Example of using IF in query--

SELECT salesorderid,
	   SubTotal,
	   TotalSum
FROM
(	   
	SELECT Sales.header.SubTotal,
		   sales.header.salesorderid,
		CASE 
			WHEN Sales.header.SubTotal BETWEEN 1000 AND 5000 THEN 'Between 1000 and 5000' 
			WHEN Sales.header.SubTotal >10000  THEN 'Greater than 10000 '
			ELSE NULL
		END AS TotalSum
	FROM Sales.Header	
)IfStatement
ORDER BY SubTotal DESC


