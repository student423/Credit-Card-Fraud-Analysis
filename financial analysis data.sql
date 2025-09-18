-- create database
CREATE DATABASE db_fraud;
USE db_fraud;

-- create table 
CREATE TABLE raw_transactions (
    Time INT,
    V1 FLOAT,
    V2 FLOAT,
    V3 FLOAT,
    V4 FLOAT,
    V5 FLOAT,
    V6 FLOAT,
    V7 FLOAT,
    V8 FLOAT,
    V9 FLOAT,
    V10 FLOAT,
    V11 FLOAT,
    V12 FLOAT,
    V13 FLOAT,
    V14 FLOAT,
    V15 FLOAT,
    V16 FLOAT,
    V17 FLOAT,
    V18 FLOAT,
    V19 FLOAT,
    V20 FLOAT,
    V21 FLOAT,
    V22 FLOAT,
    V23 FLOAT,
    V24 FLOAT,
    V25 FLOAT,
    V26 FLOAT,
    V27 FLOAT,
    V28 FLOAT,
    Amount FLOAT,
    Class TINYINT
);

-- check data
SELECT *
FROM 
    raw_transactions
LIMIT 10;

-- column name and datatypes
SHOW COLUMNS FROM raw_transactions;

-- Count fraud vs non-fraud transactions
SELECT
    COUNT(*) AS transaction_counts,
    Class,
    CONCAT(ROUND(COUNT(*)*100 / (SELECT COUNT(*) FROM raw_transactions),2),'%') AS percentage
FROM 
	raw_transactions
GROUP BY
	Class;
    
-- Basic fraud vs non-fraud transaction amounts
SELECT
    Class,
    COUNT(*) AS transaction_counts,
    ROUND(STDDEV(Amount),2) AS std_amount,
    ROUND(AVG(Amount),2) AS avg_amount,
    ROUND(MAX(Amount),2) AS max_amount,
    ROUND(MIN(Amount),2) AS min_amount
FROM 
    raw_transactions
GROUP BY
    Class;
    
-- Range of transaction time
SELECT
   MAX(Time) AS max_time,
   MIN(Time) AS min_time
FROM
   raw_transactions;
   
-- exploratory data analysis

-- Categorize transactions into buckets
SELECT
    Class,
    COUNT(*) AS transaction_count,
    CASE
      WHEN Amount<10 THEN 'Low (<10)'
      WHEN Amount BETWEEN 10 AND 100 THEN 'Medium(10-100)'
      WHEN Amount BETWEEN 100 AND 500 THEN 'Large(100-500)'
      ELSE 'Very Large(>500)'
	END AS amount_category
FROM
    raw_transactions
GROUP BY
	Class,amount_category
ORDER BY
    Class,amount_category;
    
-- Create hour column for analysis
SELECT
    FLOOR(Time/3600)%24 AS hour_days,
    Class,
    COUNT(*) AS transaction_counts
FROM
    raw_transactions
GROUP BY
    hour_days,Class
ORDER BY
    hour_days,Class;
    
-- Fraud percentage across dataset
SELECT 
    ROUND(SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 4) AS fraud_rate_percent
FROM 
    raw_transactions;