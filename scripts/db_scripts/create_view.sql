DROP VIEW IF EXISTS customer_segmentation;
GO

CREATE VIEW customer_segmentation AS
WITH total_spending_per_customer AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM
        Invoices
    GROUP BY
        customer_id
),
customer_groups AS (
    SELECT 
        customer_id,
        total_amount,
        CASE
            WHEN total_amount >= 1600 THEN 'High Spender'
            WHEN total_amount >= 650 THEN 'Medium Spender'
            ELSE 'Low Spender'
        END AS customer_group
    FROM
        total_spending_per_customer
)
SELECT * FROM customer_groups;

GO
