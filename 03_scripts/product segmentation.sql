WITH product_segment AS(
SELECT product_key, product_name, cost,

-- Categorize products into cost ranges
CASE 
    WHEN cost < 100 THEN " BELOW 100"
    WHEN cost BETWEEN 100 AND 500 THEN "BETWEEN 100 and 500"
    WHEN cost BETWEEN 500 AND 1000 THEN "BETWEEN 500 and 1000"
    ELSE "Above 1000"
END cost_range

FROM gold_dim_products)

-- Count how many products fall into each cost range
SELECT cost_range, COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
