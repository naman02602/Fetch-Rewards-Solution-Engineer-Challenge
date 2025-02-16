-- 1 What are the top 5 brands by receipts scanned for most recent month?
WITH recent_month_receipts AS (
    SELECT r.receipt_id, ri.barcode, ib.brand_id
    FROM Receipts r
    JOIN ReceiptItems ri ON r.receipt_id = ri.receipt_id
    JOIN Item_Brand ib ON ri.barcode = ib.barcode
    WHERE r.date_scanned >= DATEADD(DAY, 1, EOMONTH(GETDATE(), -1))  -- First day of last month
)

SELECT TOP 5 
    b.name AS brand_name, 
    COUNT(DISTINCT rm.receipt_id) AS receipt_count
FROM recent_month_receipts rm
JOIN Brands b ON rm.brand_id = b.brand_id
GROUP BY b.name
ORDER BY receipt_count DESC;

-- 2. How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?
WITH current_month AS (
    SELECT r.receipt_id, ri.barcode
    FROM Receipts r
    JOIN ReceiptItems ri ON r.receipt_id = ri.receipt_id
    WHERE r.purchase_date >= DATEADD(MONTH, -1, GETDATE())
),

current_month_ranking AS (
    SELECT b.name AS brand_name, 
           COUNT(DISTINCT cm.receipt_id) AS receipt_count, 
           RANK() OVER (ORDER BY COUNT(DISTINCT cm.receipt_id) DESC) AS rank
    FROM current_month cm
    JOIN Brands b ON cm.barcode = b.barcode
    GROUP BY b.name
),

previous_month AS (
    SELECT r.receipt_id, ri.barcode
    FROM Receipts r
    JOIN ReceiptItems ri ON r.receipt_id = ri.receipt_id
    WHERE r.purchase_date >= DATEADD(MONTH, -2, GETDATE()) 
          AND r.purchase_date < DATEADD(MONTH, -1, GETDATE())
),

previous_month_ranking AS (
    SELECT b.name AS brand_name, 
           COUNT(DISTINCT pm.receipt_id) AS receipt_count, 
           RANK() OVER (ORDER BY COUNT(DISTINCT pm.receipt_id) DESC) AS rank
    FROM previous_month pm
    JOIN Brands b ON pm.barcode = b.barcode
    GROUP BY b.name
)

SELECT 
    COALESCE(cmr.brand_name, pmr.brand_name) AS brand_name, 
    cmr.receipt_count AS current_receipt_count,
    cmr.rank AS current_rank, 
    pmr.receipt_count AS previous_receipt_count, 
    pmr.rank AS previous_rank
FROM current_month_ranking cmr
FULL OUTER JOIN previous_month_ranking pmr 
    ON cmr.brand_name = pmr.brand_name
ORDER BY COALESCE(cmr.rank, pmr.rank);

-- 3. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
SELECT 
    rewards_receipt_status, 
    AVG(CAST(total_spent AS FLOAT)) AS avg_spend
FROM Receipts
WHERE rewards_receipt_status IN ('Accepted', 'Rejected')
GROUP BY rewards_receipt_status
ORDER BY avg_spend DESC;


-- 4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
WITH items_comparison AS (
    SELECT 
        r.rewards_receipt_status, 
        SUM(ri.quantity_purchased) AS total_items
    FROM Receipts r
    JOIN ReceiptItems ri ON r.receipt_id = ri.receipt_id
    WHERE r.rewards_receipt_status IN ('Accepted', 'Rejected')
    GROUP BY r.rewards_receipt_status
)
SELECT rewards_receipt_status, total_items
FROM items_comparison
ORDER BY total_items DESC;

-- 5. Which brand has the most spend among users who were created within the past 6 months?
WITH recent_users AS (
    SELECT user_id
    FROM Users
    WHERE created_date >= DATEADD(MONTH, -6, GETDATE())  -- Users created in the last 6 months
),

user_receipts AS (
    SELECT r.receipt_id
    FROM recent_users ru
    JOIN Receipts r ON ru.user_id = r.user_id  -- Join receipts to users
),

receipt_items AS (
    SELECT ri.barcode, ri.final_price
    FROM user_receipts ur
    JOIN ReceiptItems ri ON ur.receipt_id = ri.receipt_id  -- Join receipt items
),

brand_spend AS (
    SELECT ib.brand_id, SUM(ri.final_price) AS total_spend
    FROM receipt_items ri
    JOIN Item_Brand ib ON ri.barcode = ib.barcode  -- Map barcode to brand_id
    GROUP BY ib.brand_id
)

SELECT TOP 1 b.name AS brand_name, bs.total_spend
FROM brand_spend bs
JOIN Brands b ON bs.brand_id = b.brand_id  -- Get brand names
ORDER BY bs.total_spend DESC;  -- Select the brand with the highest total spend

-- 6. Which brand has the most transactions among users who were created within the past 6 months?
WITH recent_users AS (
    SELECT user_id
    FROM Users
    WHERE created_date >= DATEADD(MONTH, -6, GETDATE())  -- Get users created in the last 6 months
),

user_receipts AS (
    SELECT r.receipt_id
    FROM recent_users ru
    JOIN Receipts r ON ru.user_id = r.user_id  -- Join receipts to recent users
),

receipt_items AS (
    SELECT ri.barcode
    FROM user_receipts ur
    JOIN ReceiptItems ri ON ur.receipt_id = ri.receipt_id  -- Join receipt items
),

brand_transactions AS (
    SELECT ib.brand_id, COUNT(*) AS total_transactions
    FROM receipt_items ri
    JOIN Item_Brand ib ON ri.barcode = ib.barcode  -- Map barcode to brand_id
    GROUP BY ib.brand_id
)

SELECT TOP 1 b.name AS brand_name, bt.total_transactions
FROM brand_transactions bt
JOIN Brands b ON bt.brand_id = b.brand_id  -- Join to get brand names
ORDER BY bt.total_transactions DESC;  -- Get the brand with the most transactions
