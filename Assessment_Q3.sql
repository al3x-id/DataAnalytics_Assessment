-- Task 3. Account Inactivity Alert

SELECT 
    s.plan_id,
    s.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'None'
    END AS `type`,
    last_transaction.last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction.last_transaction_date) AS inactivity_days
FROM (

-- Subquery to get last transaction per account
    SELECT 
        plan_id,
        owner_id,
        MAX(DATE_FORMAT(created_on, '%Y-%m-%d')) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id, owner_id
) AS last_transaction 
--
JOIN plans_plan p 
	ON p.id = last_transaction.plan_id
JOIN savings_savingsaccount s 
	ON s.plan_id = last_transaction.plan_id 
	AND s.owner_id = last_transaction.owner_id
WHERE DATEDIFF(CURRENT_DATE, last_transaction.last_transaction_date) > '365 days'
ORDER BY inactivity_days DESC;
