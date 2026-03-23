WITH yearly_product_sales AS(
    SELECT 
        YEAR(f.order_date) AS orderdate, 
        p.product_name,
        SUM(f.sales_amount) AS Total_sales
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON f.product_key = p.product_key
    WHERE YEAR(f.order_date) IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)

SELECT 
    orderdate,
    product_name,
    total_sales,
    
    -- Calculate the average yearly sales for each product
    AVG(Total_sales) OVER (PARTITION BY product_name) AS average_sales,
    
    -- Find the difference between current sales and the average sales
    total_sales - AVG(Total_sales) OVER (PARTITION BY product_name) AS diff_avg,
    
    -- Get the previous year's sales for the same product
    LAG(Total_sales) OVER (PARTITION BY product_name ORDER BY orderdate) AS previous_sales,
    
    -- Classify whether current sales are above, below, or equal to average
    CASE 
        WHEN total_sales - AVG(Total_sales) OVER (PARTITION BY product_name) > 0 THEN "Above Average"
        WHEN total_sales - AVG(Total_sales) OVER (PARTITION BY product_name) < 0 THEN "Below Average"
        ELSE "AVG"
    END avg_change	
FROM yearly_product_sales
ORDER BY product_name, orderdate;