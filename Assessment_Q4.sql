-- Task 4. Customer Lifetime Value (CLV) Estimation

SELECT
    u.id AS customer_id,
    CONCAT_WS(" ", first_name, last_name) AS `name`,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    COUNT(s.id) AS total_transactions,

-- Estimating the customer lifetime value
    ROUND(
        (COUNT(s.id)/
        
-- using NULLIF to prevent division by zero
        NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0)) * 12 *
        (0.001 * AVG(s.confirmed_amount / 100.0)),
        2
    ) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
GROUP BY u.id, u.name, u.date_joined
ORDER BY estimated_clv DESC;
