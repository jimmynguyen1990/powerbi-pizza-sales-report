-- Create table tbl_pizza_sale
CREATE TABLE tbl_pizza_sale (
	pizza_id integer primary key,
	order_id integer,
	pizza_name_id varchar(100),
	quantity integer,
	order_date date,
	order_time time,
	unit_price numeric(4,2),
	total_price numeric(7,2),
	pizza_size varchar(3),
	pizza_category varchar(50),
	pizza_ingredients varchar(400),
	pizza_name varchar(100)
);

-- Import data from csv file into table tbl_pizza_sale
COPY tbl_pizza_sale(pizza_id,order_id,pizza_name_id,quantity,order_date,order_time,unit_price,
					total_price,pizza_size,pizza_category,pizza_ingredients,pizza_name)
FROM 'E:\powerbi-wp\Data Analyst Project - SQL+PowerBI+Excel\pizza_sales.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM tbl_pizza_sale

/*Calculate KPIs*/
-- Total revenue
SELECT SUM(total_price) AS total_revenue
FROM tbl_pizza_sale 

-- Average order value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS avg_order_value
FROM tbl_pizza_sale

-- Total pizzas sold
SELECT SUM(quantity) AS total_pizzas_sold
FROM tbl_pizza_sale

-- Total orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM tbl_pizza_sale

-- Average pizzas per order
SELECT CAST(CAST(SUM(quantity) AS numeric(10,2)) / CAST(COUNT(DISTINCT order_id) AS numeric(10,2)) AS numeric(10,2))  AS avg_pizzas_per_order
FROM tbl_pizza_sale

/*Calculate daily trend for total orders*/
SELECT TO_CHAR(order_date, 'day') AS order_day, COUNT(DISTINCT order_id) AS total_orders
FROM tbl_pizza_sale
GROUP BY TO_CHAR(order_date, 'day')

/*Monthly trend for orders*/
SELECT TO_CHAR(order_date, 'month') AS order_month, COUNT(DISTINCT order_id) AS total_orders
FROM tbl_pizza_sale
GROUP BY TO_CHAR(order_date, 'month')

/*Percentage of sales by pizza category*/
SELECT pizza_category, CAST(SUM(total_price) AS numeric(10,2)) AS total_revenue_by_category,
		CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM tbl_pizza_sale) AS numeric(10,2)) AS sale_pct
FROM tbl_pizza_sale
GROUP BY pizza_category

/*Percentage of sales by pizza size*/
SELECT pizza_size, CAST(SUM(total_price) AS numeric(10,2)) AS total_revenue_by_size,
		CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM tbl_pizza_sale) AS numeric(10,2)) AS sale_pct
FROM tbl_pizza_sale
GROUP BY pizza_size
ORDER BY sale_pct DESC

/*Total pizzas sold by pizza category*/
SELECT pizza_category, SUM(quantity) AS total_quantity_by_category
FROM tbl_pizza_sale
-- WHERE EXTRACT(MONTH FROM order_date) = 2
GROUP BY pizza_category
ORDER BY total_quantity_by_category DESC

/*Count distinct pizza names*/
SELECT COUNT(DISTINCT pizza_name) AS count_pizza_name
FROM tbl_pizza_sale

/*Top 5 pizzas by revenue*/
SELECT pizza_name, SUM(total_price) AS total_revenue_by_name
FROM tbl_pizza_sale
GROUP BY pizza_name
ORDER BY total_revenue_by_name DESC
LIMIT 5

/*Bottom 5 pizzas by revenue*/
SELECT pizza_name, SUM(total_price) AS total_revenue_by_name
FROM tbl_pizza_sale
GROUP BY pizza_name
ORDER BY total_revenue_by_name ASC
LIMIT 5

/*Top 5 pizzas by quantity*/
SELECT pizza_name, SUM(quantity) AS total_quantity_by_name
FROM tbl_pizza_sale
GROUP BY pizza_name
ORDER BY total_quantity_by_name DESC
LIMIT 5

/*Bottom 5 pizzas by quantity*/
SELECT pizza_name, SUM(quantity) AS total_quantity_by_name
FROM tbl_pizza_sale
GROUP BY pizza_name
ORDER BY total_quantity_by_name ASC
LIMIT 5

/*Top 5 pizzas by order*/
SELECT pizza_name, COUNT(DISTINCT(order_id)) AS total_order_by_name
FROM tbl_pizza_sale
GROUP BY pizza_name
ORDER BY total_order_by_name DESC
LIMIT 5

/*Bottom 5 pizzas by order*/
SELECT pizza_name, COUNT(DISTINCT(order_id)) AS total_order_by_name
FROM tbl_pizza_sale
GROUP BY pizza_name
ORDER BY total_order_by_name ASC
LIMIT 5

