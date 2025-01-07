CREATE DATABASE RetailDB;
USE RetailDB;

CREATE TABLE RetailOrders (
	Order_Id INT primary key,
    Order_Date DATE,
    Ship_Mode VARCHAR(50),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Id VARCHAR(50),
    Quantity INT,
    Discount FLOAT,
    Sales_Price FLOAT,
    Profit FLOAT
);

select * from RetailOrders;
drop table retailorders;
truncate TABLE retailorders;

-- 1
select Product_id ,round(sum(sales_price),4) sales from retailorders
group by product_id
order by sales desc
limit 10;

-- 2

select Region,product_id,total_quantity,rank_s 
from
(select Region,product_id,total_quantity,dense_rank() over(partition by region order by total_quantity desc) as rank_s
 from
(SELECT Region,product_id,SUM(quantity) AS total_quantity from retailorders
group by Product_Id,region)
as newtab1)
as newtab2
where rank_s <=5;

-- 3

with newtab1 as
(select category,round(sum(sales_price),2) as sales,month(order_date) as months from retailorders
group by Category,months),
newtab2 as
(select category,max(sales) as sales,months from newtab1
group by category)
select n1.category,n1.sales,n1.months from newtab1 n1 
join newtab2 n2 on n1.category=n2.category and n1.sales=n2.sales;

-- 4

WITH sales_data AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(sales_price) AS total_sales
    FROM retailorders
    WHERE order_date BETWEEN '2022-01-01' AND '2023-12-31'
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
    s1.year AS year_2022,
    s1.month AS month_2022,
    s1.total_sales AS sales_2022,
    s2.year AS year_2023,
    s2.month AS month_2023,
    s2.total_sales AS sales_2023,
    ROUND(((s2.total_sales - s1.total_sales) / NULLIF(s1.total_sales, 0)) * 100, 2) AS growth_percentage
FROM sales_data s1
JOIN sales_data s2 ON s1.month = s2.month AND s1.year = 2022 AND s2.year = 2023
ORDER BY s1.month;

-- 5

select * from retailorders
order by year(Order_Date),month(Order_Date);

-- 6

WITH profit_data AS (
    SELECT
		Sub_Category,
        YEAR(order_date) AS year,
        SUM(Profit) AS total_profit
    FROM retailorders
    WHERE order_date BETWEEN '2022-01-01' AND '2023-12-31'
    GROUP BY Sub_Category,YEAR(order_date)
),
profit_growth AS (SELECT
	s1.Sub_Category,
    s1.year AS year_2022,
    s1.total_profit AS profit_2022,
    s2.year AS year_2023,
    s2.total_profit AS profit_2023,
    ROUND(((s2.total_profit - s1.total_profit) / NULLIF(s1.total_profit, 0)) * 100, 2) AS growth_percentage
FROM profit_data s1
JOIN profit_data s2 ON s1.sub_category=s2.sub_category and s1.year = 2022 AND s2.year = 2023)
SELECT
    sub_category,
    profit_2022,
    profit_2023,
    growth_percentage
FROM profit_growth
ORDER BY growth_percentage DESC
LIMIT 1;
