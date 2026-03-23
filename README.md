Customer Report
Overview
This project presents a SQL-based customer report that combines demographic, transactional, and behavioral data into a single analytical view. It helps segment customers and calculate key KPIs for business analysis and dashboarding.
Objective
The goal of this report is to analyze customer behavior, measure spending activity, and classify customers into meaningful groups for reporting and decision-making.
Tools Used
MySQL
Tableau
Data Sources
gold_fact_sales
gold_dim_customers
Key Features
customer age grouping
customer segmentation into VIP, Regular, and NEW
total orders, total sales, and quantity purchased
recency, lifespan, average order value, and average monthly spend
Segmentation Rules
Customer Segments
VIP: total_sales > 5000 and lifespan >= 12
Regular: total_sales <= 5000 and lifespan >= 12
NEW: lifespan < 12
Age Groups
UNDER 20
20–29
30–39
40–49
50–59
OVER 59
Use Case
This report can be used in Tableau to create dashboards for customer analysis, segmentation, and KPI tracking.
Author
Created as part of a customer analytics project using SQL