SELECT
	CAST(ROUND(SUM(quantity * unit_price),2) AS DECIMAL(10,2)) AS total_amount
FROM
	Invoices
WHERE
	unit_price > 0
	AND quantity > 0
GROUP BY 
	invoice_no;

GO