-- Task 1. High-Value Customers with Multiple Products

SELECT 
    u.id AS owner_id,
    CONCAT_WS(" ", first_name, last_name) AS `name`,  
    up.savings_count,
    up.investment_count,
    ROUND(up.total_kobo / 100.0, 2) AS total_deposits
FROM users_customuser u

-- using the subquery to calculate the savings and investment plan for each user
JOIN (
    SELECT 
        s.owner_id,
        
-- Counting how many savings and investment the users had
        COUNT(
        DISTINCT CASE 
			WHEN p.is_regular_savings = 1
            THEN s.plan_id 
		END) AS savings_count, 
        COUNT(
        DISTINCT CASE 
			WHEN p.is_a_fund = 1 
			THEN s.plan_id 
		END) AS investment_count, 
-- 
        SUM(s.confirmed_amount) AS total_kobo
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id 
    WHERE s.confirmed_amount > 0   
    GROUP BY s.owner_id
    
-- filter to keep user who  have both: atleast 1 savings and 1 investment plan
    HAVING 
        COUNT(
        DISTINCT CASE 
			WHEN p.is_regular_savings = 1 
            THEN s.plan_id 
		END) > 0
		AND
        COUNT(
        DISTINCT CASE
			WHEN p.is_a_fund = 1 
			THEN s.plan_id 
		END) > 0
) up
-- 
ON u.id = up.owner_id
ORDER BY total_deposits DESC;
