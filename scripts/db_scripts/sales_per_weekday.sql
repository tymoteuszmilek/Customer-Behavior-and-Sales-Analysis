WITH total_amount AS (
SELECT
	SUM(quantity * unit_price) as total
FROM	
	Invoices
),
weekday_num_total_amount AS (
SELECT
	DATEPART(WEEKDAY,invoice_date) AS weekday_num,
	CAST(ROUND(SUM(quantity * unit_price) *100/ total,2) AS DECIMAL(4,2)) AS percentage
FROM
	Invoices
CROSS JOIN
	total_amount
GROUP BY
	DATEPART(WEEKDAY, invoice_date), total
)
SELECT
	(CASE
		WHEN weekday_num = 1 THEN 'Sunday'
		WHEN weekday_num = 2 THEN 'Monday'
		WHEN weekday_num = 3 THEN 'Tuesday'
		WHEN weekday_num = 4 THEN 'Wednesday'
		WHEN weekday_num = 5 THEN 'Thursday'
		WHEN weekday_num = 6 THEN 'Friday'
		WHEN weekday_num = 7 THEN 'Saturday'
		END) AS weekday_name,
		percentage
FROM
	weekday_num_total_amount
ORDER BY
	CASE
		WHEN weekday_num = 1 THEN 7
		WHEN weekday_num = 2 THEN 1
		WHEN weekday_num = 3 THEN 2
		WHEN weekday_num = 4 THEN 3
		WHEN weekday_num = 5 THEN 4
		WHEN weekday_num = 6 THEN 5
		WHEN weekday_num = 7 THEN 6
	END;
	
GO
		