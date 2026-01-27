-- Sales Performance & Business Insight Analysis
-- Database  : MySQL
-- Author    : Salsabila Eka Hariadi
-- --------------------------------------------------------------

-- DATA
CREATE DATABASE sales_portfolio;
USE sales_portfolio;
SELECT * FROM sales_data
LIMIT 10;
SELECT COUNT(*) AS total_rows
FROM sales_data;

-- DATA QUALITY CHECK
SELECT *
FROM sales_data
WHERE order_id IS NULL
   OR order_date IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL;

-- Check Missing Values
SELECT
  SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
  SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS missing_profit
FROM sales_data;

-- Duplicate Order Check
SELECT order_id, COUNT(*)
FROM sales_data
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Negative Values
SELECT *
FROM sales_data
WHERE sales < 0
   OR quantity <= 0
   OR discount < 0;

-- Struktur Tabel
DESCRIBE sales_data;

-- Tipe Data
ALTER TABLE sales_data
MODIFY order_date DATE,
MODIFY ship_date DATE,
MODIFY sales DECIMAL(10,2),
MODIFY profit DECIMAL(10,2),
MODIFY quantity INT,
MODIFY discount DECIMAL(4,2);

-- FEATURE ENGINEERING
-- Create Year & Month
SELECT
  order_id,
  YEAR(order_date) AS year,
  MONTH(order_date) AS month
FROM sales_data;

-- Total Sales
SELECT SUM(Sales) AS total_sales
FROM sales_data;

-- Total Profit
SELECT SUM(Profit) AS total_profit
FROM sales_data;

-- Profit Margin
SELECT
  (SUM(Profit) / SUM(Sales)) * 100 AS profit_margin_pct
FROM sales_data;

-- SALES PERFORMANCE
-- Total Sales per Month
SELECT
  DATE_FORMAT(order_date, '%Y-%m') AS month,
  SUM(sales) AS total_sales
FROM sales_data
GROUP BY month
ORDER BY month;

-- Top 10 Product by Sales
SELECT
  product_id,
  SUM(sales) AS total_sales
FROM sales_data
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;

-- CUSTOMER ANALYSIS
-- Top 10 Customers by Revenue
SELECT
  customer_id,
  SUM(sales) AS total_sales
FROM sales_data
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 10;

-- Customer Contribution Percentage
SELECT
  customer_id,
  SUM(sales) AS total_sales,
  ROUND(
    SUM(sales) / (SELECT SUM(sales) FROM sales_data) * 100, 2
  ) AS contribution_pct
FROM sales_data
GROUP BY customer_id
ORDER BY contribution_pct DESC;

-- REGIONAL ANALYSIS
-- Sales by Region
SELECT
  region,
  SUM(sales) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;

-- Market Performance Comparison
SELECT
  market,
  SUM(sales) AS total_sales,
  SUM(profit) AS total_profit
FROM sales_data
GROUP BY market;

-- ADVANCED ANALYSIS
-- Customer Ranking (WINDOW FUNCTION)
SELECT
  customer_id,
  SUM(sales) AS total_sales,
  RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM sales_data
GROUP BY customer_id;

-- Discount Impact Analysis
SELECT
  CASE
    WHEN Discount = 0 THEN 'No Discount'
    WHEN Discount <= 0.2 THEN 'Low Discount'
    ELSE 'High Discount'
  END AS discount_category,
  SUM(Sales) AS total_sales,
  SUM(Profit) AS total_profit
FROM sales_data
GROUP BY discount_category;




