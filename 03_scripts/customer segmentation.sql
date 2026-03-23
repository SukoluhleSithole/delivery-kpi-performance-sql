WITH segmented_c AS (
    SELECT 
        customer_id,
        
        -- Calculate total spending per customer
        SUM(sales_amount) AS total_sales,
        
        -- Get the most recent and earliest order dates
        MAX(order_date) AS last_order,
        MIN(order_date) AS first_order,
        
        -- Calculate customer lifespan in months
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        
        -- Classify customers into segments based on total sales and lifespan
        CASE 
            WHEN SUM(sales_amount) > 5000 
                 AND TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 
                THEN 'VIP'
                
            WHEN SUM(sales_amount) <= 5000 
                 AND TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 
                THEN 'Regular'
                
            ELSE 'NEW'
        END AS customer_seg
        
    FROM gold_dim_customers c
    LEFT JOIN gold_fact_sales f
        ON c.customer_key = f.customer_key
        
    -- Group results by customer
    GROUP BY customer_id
    
    -- Sort customers in ascending order
    ORDER BY customer_id ASC
)

-- Count the number of customers in each segment
SELECT 
    customer_seg,
    COUNT(customer_seg) AS customer_count
FROM segmented_c
GROUP BY customer_seg;
