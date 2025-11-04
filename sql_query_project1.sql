-- SQL Retail Sales Analysis - p1
CREATE DATABASE sql_practice_p2;

-- Create Tables 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE reatail_sales 
	(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
	);
-- to check the datas in tables 
SELECT * FROM reatail_sales
LIMIT 10;

-- to get the count
SELECT COUNT(*) FROM reatail_sales;

-- TO CHECK THE NULL VALUES (DATA CLEANING)
SELECT * 
FROM reatail_sales
WHERE transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR 
	total_sale IS NULL;

-- DELETING THE NULL VALUES
DELETE FROM reatail_sales
WHERE transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR 
	total_sale IS NULL;

-- DATA EXPORATION
-- how many sales we have?
SELECT COUNT(*) AS total_sale FROM reatail_sales;
-- how many UNIQUE customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM reatail_sales;
-- how many different category we have?
SELECT DISTINCT category  AS diff_category FROM reatail_sales;

-- DATA ANALYSIS
--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'?

SELECT 
	* 
FROM 
	reatail_sales 
WHERE 
	sale_date = '2022-11-05';
--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022?


SELECT 
	* 
FROM 
	reatail_sales 
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM')  = '2022-11'
	AND
	quantiy <= 4;

--Q3. Write a SQL query to calculate the total sales (total_sale) for each category?

SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_order
FROM reatail_sales
GROUP BY category;

--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?

SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM
	reatail_sales
WHERE
	category = 'Beauty';
--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000?

SELECT * 
FROM reatail_sales
WHERE total_sale > 1000;

--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?

SELECT 
category,
gender,
count(*) AS total_trans
FROM reatail_sales
GROUP BY
category,gender
ORDER BY 1;

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?
 
 select 
 	year, 
	month,
	avg_sale
 from 
 (
	 select 
	 	extract(YEAR FROM sale_date) as year,
		extract(MONTH FROM sale_date)as month,
		avg(total_sale) as avg_sale,
		rank() over (partition by extract(YEAR FROM sale_date) order by avg(total_sale) desc) as rank
	from
		reatail_sales
	group by 
		year,
		month
	)as t1
where 
	rank = 1;

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales?

select 
	customer_id,
	sum(total_sale) as top_sale
from 
	reatail_sales
group by 
	1
order by 
	2 desc
limit 5 ;

--Q9. Write a SQL query to find the number of unique customers who purchased items from each category?

select category, count(distinct customer_id) as cust_ids
from reatail_sales
group by category

--Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?

with hourly_sale as(
	select 
		*,
		case
			when extract(HOUR from sale_time) < 12 then 'morning' 
			when extract(HOUR from sale_time) between 12 AND 17 then 'afternoon'
			else 'evening'
			end as shift
	from reatail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;

--END OF PROJECt 
