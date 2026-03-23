/*
Customer Report
==================
Purpose:
- This report consolidates key customer metrics and behaviors

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order value
   - average monthly spend
*/

CREATE VIEW customers_report AS 

/*
1) Base Query: Retrieves core columns from tables
==================================================
*/
WITH base_query AS (
    SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        CONCAT(c.first_name, " ", c.last_name) AS fullname,
        c.birthdate,
        TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()) AS age
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_customers c
        ON f.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
),

/*
2) Customer_aggregation: Summarises key metrics at customer level
==================================================
*/
customer_aggregation AS (
    SELECT 
        fullname,
        customer_key,
        age,
        COUNT(DISTINCT(order_number)) AS no_order,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_qauntity,
        COUNT(DISTINCT(product_key)) AS no_products,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        fullname,
        customer_key,
        age
    ORDER BY lifespan DESC
)

/*
3) Final Query: Creates the customer report view
==================================================
*/
SELECT
    customer_key,
    fullname,
    age,

    CASE 
        WHEN age < 20 THEN "UNDER 20"
        WHEN age BETWEEN 20 AND 29 THEN "20-29"
        WHEN age BETWEEN 30 AND 39 THEN "30-39"
        WHEN age BETWEEN 40 AND 49 THEN "40-49"
        WHEN age BETWEEN 50 AND 59 THEN "50-59"
        ELSE "OVER 59"
    END age_groups,

    CASE 
        WHEN total_sales > 5000 AND lifespan >= 12 THEN "VIP"
        WHEN total_sales <= 5000 AND lifespan >= 12 THEN "Regular"
        ELSE "NEW"
    END customer_seg,

    last_order,
    TIMESTAMPDIFF(MONTH, last_order, CURDATE()) AS last_order_date,
    no_order,
    total_sales,
    total_qauntity,
    no_products,
    lifespan,

    -- Compute average order value
    CASE 
        WHEN total_sales = 0 THEN 0
        ELSE ROUND(total_sales / no_order, 2)
    END AS avg_order_value,

    -- Compute average monthly sales
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS average_total_spend

FROM customer_aggregation;
