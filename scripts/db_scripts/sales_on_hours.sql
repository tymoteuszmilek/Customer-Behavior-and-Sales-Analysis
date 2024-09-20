-- Create new column that will store h
WITH order_hour AS (
SELECT
	quantity,
	unit_price,
	DATEPART(HOUR, invoice_date) AS hour
FROM
	Invoices
),
total_amount AS (
SELECT
	SUM(quantity * unit_price) as total
FROM	
	Invoices
)
SELECT
	hour,
	CAST(ROUND(SUM(quantity * unit_price) * 100 / total,2) AS DECIMAL(4,2)) AS percentage
	
FROM
	order_hour
CROSS JOIN
	total_amount
WHERE   
    quantity > 0
GROUP BY
	hour, total
ORDER BY hour;

GO