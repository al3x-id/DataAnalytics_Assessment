-- Task 2. Transaction Frequency Analysis

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transaction_per_month), 1) AS avg_transactions_per_month
FROM (

-- Subquery to get average monthly transactions per customer and Categorize customers by their average transaction frequency
    SELECT 
        owner_id,
        ROUND(AVG(monthly_transaction_count), 1) AS avg_transaction_per_month,
        CASE 
            WHEN ROUND(AVG(monthly_transaction_count), 1) >= 10 THEN 'High Frequency'
            WHEN ROUND(AVG(monthly_transaction_count), 1) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM (
	
-- Subquery to Count transactions per customer per month
        SELECT 
            owner_id,
            DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
            COUNT(*) AS monthly_transaction_count
        FROM savings_savingsaccount
        GROUP BY owner_id, DATE_FORMAT(transaction_date, '%Y-%m')
    ) AS monthly_data
-- 
    GROUP BY owner_id
) AS categorized_customers
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
    