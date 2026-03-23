WITH sales_category AS 
(
    SELECT 
        category,
        SUM(sales_amount) total_sales
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON f.product_key = p.product_key
    GROUP BY category
)

SELECT 
    category, 
    total_sales,
    
    -- Calculate overall total sales across all categories
    SUM(total_sales) OVER() total,
    
    -- Calculate each category's percentage contribution to total sales
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') propotions
FROM sales_category

-- Display categories from highest to lowest sales
ORDER BY total_sales DESC