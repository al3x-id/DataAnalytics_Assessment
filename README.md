# DataAnalytics_Assessment

- Tool used: MySQL
---

## Approach to Each Question

### 1. **High-Value Customers with Multiple Products**
**Task:** Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

**Approach:**
[Assessment_Q1](Assessment_Q1.sql)
- Used `JOIN` to combine `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
- Used conditional `COUNT(DISTINCT )` to count unique plan types i.e to count how many savings and investment each users had.
- Applied `HAVING` clause to filter users who have both: atleast 1 savings and 1 investment plan ensuring both plan types are present.
- Applied `WHERE` clause with the comparison operator `>` to filter out where money has not being deposited
- Divided total deposit by 100 to convert from kobo to naira.
- Used `CONCAT_WS()` to add the `first_name` and the `last_name` to form the `name` column
---

### 2. **Transaction Frequency Analysis**
**Task:** Calculate the average number of transactions per customer per month and classify them into High, Medium, or Low frequency.

**Approach:**
[Assessment_Q2](Assessment_Q2.sql)
- Created subqueries
  - To Count transactions per customer per month using `DATE_FORMAT()` function to extract month from the transaction date
  - To Calculate average monthly transactions per user and used a `CASE` statement to bucket customers into frequency categories.
- Grouped by category to find total customers and average transactions per group.
---

### 3. **Account Inactivity Alert**
**Task:** Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

**Approach:**
[Assessment_Q3](Assessment_Q3.sql)
- Used a subquery to get the last transaction date per account using `DATE_FORMAT()` to extract just the date.
- Used Join `last_transaction_date` to `plans_plan` to check if each plan is a Savings or Investment.
- Compared this date to `CURRENT_DATE - 365` using `DATEDIFF()` to determine inactivity.
- Used Join again (to `savings_savingsaccount`) to match each last transaction to its original record to retrieve the owner_id and other fields.
- Filtered for Inactive Accounts whose last transaction date was more than 365 days ago using `WHERE` with comparison operator `>`.

---

### 4. **Customer Lifetime Value (CLV) Estimation**
**Task:** Calculate the estimated CLV for each customer based on average profit per transaction.

**Approach:**
[Assessment_Q4](Assessment_Q4.sql)
- Connected each user to all their savings transactions using the owner_id.
- Subtracted the user's from the current date and extract how many months they’ve had an account using `TIMESTAMPDIFF()`.
- Counted how many transactions (records in the savings table) each customer has made.
- Estimate the Customer Lifetime Value using:
  - the number of transactions per month (total / tenure) multiplying by 12 to annualize it
  - then multiply by the average profit per transaction (which is 0.1% of the transaction amount, in naira, not kobo) using NULLIF to prevent division by zero error.
- Ordered results from the highest CLV to the lowest, so the best customers show at the top.

---

## Challenges & Solutions

### Challenge: Avoiding Zero Division
- **Problem:** Tenure could be zero for recent users.
- **Solution:** Used `NULLIF` in the denominator to avoid division by zero errors.

### Challenge: Bucket Categorization in SQL
- **Problem:** Categorizing continuous transaction data into labeled frequency groups.
- **Solution:** Used `CASE` statements in a subquery to assign categories before aggregation.

### Challenge: Complex Joins & Readability
- **Problem:** Queries got long and hard to read when combining multiple joins and calculations.
- **Solution:** Broke down queries using subqueries to maintain clarity.
