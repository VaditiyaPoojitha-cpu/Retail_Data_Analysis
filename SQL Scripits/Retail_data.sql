CREATE DATABASE Retail_data

SELECT * FROM Customers
SELECT * FROM Order_Details
SELECT * FROM Orders
SELECT * FROM Categories
SELECT * FROM Products

--1.Clean NULL Values
SELECT 
    OrderID,
    ProductID,
    IsReturned,
    CASE 
        WHEN IsReturned = 0 THEN 'N/A' 
        ELSE CAST(ReturnDate AS VARCHAR) 
    END AS FormattedReturnDate
FROM order_details;

--2.Category Financial Performance & Return Rates
SELECT CategoryName,COUNT(DISTINCT OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalUnitsSold,
	ROUND(SUM(RealizedRevenue),2) AS TotalRealizedRevenue,
	ROUND(SUM(RealizedProfit),2) AS TotalRealizedProfit,
	ROUND((SUM(RealizedProfit) / NULLIF(SUM(RealizedRevenue),0)) * 100 ,2) AS ProfitMarginPercent,
	SUM(CASE WHEN IsReturned = 1 THEN 1 ELSE 0 END) AS TotalReturns,
	ROUND((SUM(CASE WHEN IsReturned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS ReturnRatePercent
FROM Order_Details
GROUP BY CategoryName
ORDER BY TotalRealizedRevenue DESC;

--3.RFM Segmentation (Recency, Frequency, Monetary)
WITH CustomerRFM AS (
	SELECT o.CustomerID,c.CustomerSegment,MAX(o.OrderDate) AS LastOrderDate,
	COUNT(DISTINCT o.OrderID) AS Frequency,ROUND(
            SUM(
                CASE 
                    WHEN od.IsReturned = 1 THEN 0.00 
                    ELSE od.Quantity * od.UnitPrice * (1 - od.DiscountRate) 
                END
            ), 2
        ) AS MonetaryValue
    FROM Orders AS o
    JOIN Customers AS c 
	ON o.CustomerID = c.CustomerID
    JOIN Order_Details AS od 
	ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID, c.CustomerSegment
)
SELECT CustomerID,CustomerSegment,LastOrderDate,Frequency,MonetaryValue,
	NTILE(4) OVER (ORDER BY LastOrderDate ASC) AS RecencyScore,
	NTILE(4) OVER (ORDER BY Frequency ASC) AS FrequencyScore,
	NTILE(4) OVER (ORDER BY MonetaryValue ASC) AS MonetaryScore
FROM CustomerRFM
ORDER BY MonetaryValue DESC;

--4.Month-over-Month (MoM) Realized Revenue Growth
WITH MonthlySales AS (
    SELECT 
        FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth, 
        ROUND(
            SUM(
                CASE 
                    WHEN od.IsReturned = 1 THEN 0.00 
                    ELSE od.Quantity * od.UnitPrice * (1 - od.DiscountRate) 
                END
            ), 2
        ) AS MonthlyRevenue
    FROM Orders AS o
	JOIN Order_Details AS od
	ON o.OrderID = od.OrderID
    GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
)
SELECT 
    YearMonth,
    MonthlyRevenue,
    LAG(MonthlyRevenue, 1) OVER (ORDER BY YearMonth) AS PreviousMonthRevenue,
    ROUND(
        ((MonthlyRevenue - LAG(MonthlyRevenue, 1) OVER (ORDER BY YearMonth)) / 
        NULLIF(LAG(MonthlyRevenue, 1) OVER (ORDER BY YearMonth), 0)) * 100, 2
    ) AS RevenueGrowthPercent
FROM MonthlySales
ORDER BY YearMonth ASC;
