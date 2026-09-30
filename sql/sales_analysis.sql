-- Sales & Customer Analytics
-- SQL Analysis using MySQL

USE sales;

-- 1. Overall KPIs
SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    SUM(Sales) / COUNT(DISTINCT `Order ID`) AS Average_Order_Value
FROM superstore_sales_analytics;


-- 2. Sales and Profit by Category
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore_sales_analytics
GROUP BY Category
ORDER BY Total_Sales DESC;


-- 3. Profit Margin by Category
SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore_sales_analytics
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;


-- 4. Monthly Sales and Profit
SELECT
    LEFT(`Order Date`, 7) AS Month_Date,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_sales_analytics
GROUP BY LEFT(`Order Date`, 7)
ORDER BY LEFT(`Order Date`, 7);


-- 5. Top 10 Products by Sales
SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore_sales_analytics
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 10;


-- 6. Top 10 Customers by Sales
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore_sales_analytics
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;
-- 7. Top 10 Products by Profit
SELECT
    `Product Name`,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore_sales_analytics
GROUP BY `Product Name`
ORDER BY Total_Profit DESC
LIMIT 10;


-- 8. Regional Performance
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore_sales_analytics
GROUP BY Region
ORDER BY Total_Sales DESC;


-- 9. High-Profit Regions
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_sales_analytics
GROUP BY Region
HAVING SUM(Profit) > 8500000
ORDER BY Total_Profit DESC;


-- 10. Order Value Classification using CASE
SELECT
    `Order ID`,
    `Customer Name`,
    Sales,
    CASE
        WHEN Sales >= 50000 THEN 'High Value'
        WHEN Sales >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Value_Category
FROM superstore_sales_analytics
LIMIT 20;


-- 11. Customer Profit Analysis
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore_sales_analytics
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Profit DESC
LIMIT 10;


-- 12. Discount vs Profit
SELECT
    Discount,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore_sales_analytics
GROUP BY Discount
ORDER BY Discount;


-- 13. Least-Profitable Products
SELECT
    `Product Name`,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore_sales_analytics
GROUP BY `Product Name`
ORDER BY Total_Profit ASC
LIMIT 10;


-- 14. Shipping Performance
SELECT
    `Ship Mode`,
    ROUND(
        AVG(
            DATEDIFF(
                STR_TO_DATE(`Ship Date`, '%Y-%m-%d'),
                STR_TO_DATE(`Order Date`, '%Y-%m-%d')
            )
        ), 2
    ) AS Average_Shipping_Days,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore_sales_analytics
GROUP BY `Ship Mode`
ORDER BY Average_Shipping_Days;


-- 15. Customer Sales and Profit using INNER JOIN
SELECT
    s.`Customer ID`,
    s.`Customer Name`,
    s.Total_Sales,
    p.Total_Profit
FROM
(
    SELECT
        `Customer ID`,
        `Customer Name`,
        ROUND(SUM(Sales), 2) AS Total_Sales
    FROM superstore_sales_analytics
    GROUP BY `Customer ID`, `Customer Name`
) s
INNER JOIN
(
    SELECT
        `Customer ID`,
        ROUND(SUM(Profit), 2) AS Total_Profit
    FROM superstore_sales_analytics
    GROUP BY `Customer ID`
) p
ON s.`Customer ID` = p.`Customer ID`
ORDER BY s.Total_Sales DESC
LIMIT 10;
-- 16. Rank Products Within Each Category
SELECT
    Category,
    `Product Name`,
    Total_Sales,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank
FROM
(
    SELECT
        Category,
        `Product Name`,
        SUM(Sales) AS Total_Sales
    FROM superstore_sales_analytics
    GROUP BY Category, `Product Name`
) AS product_sales
ORDER BY Category, Sales_Rank;


-- 17. Yearly Performance
SELECT
    LEFT(`Order Date`, 4) AS Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM superstore_sales_analytics
GROUP BY LEFT(`Order Date`, 4)
ORDER BY Year;