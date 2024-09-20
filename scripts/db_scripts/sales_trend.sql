-- extract month, year
WITH month_year AS (
	SELECT
		DATEPART(YEAR,invoice_date) AS year,
		DATEPART(MONTH, invoice_date) AS month,
		SUM(quantity * unit_price) AS total_amount
	FROM
		Invoices
	GROUP BY
		DATEPART(YEAR,invoice_date), DATEPART(MONTH, invoice_date)
)
SELECT 
	CONCAT(month, '-', year) AS month_year,
    total_amount
FROM 
	month_year
WHERE
	NOT(month = 12 AND year = 2011)
ORDER BY 
	year, month;
	
GO
