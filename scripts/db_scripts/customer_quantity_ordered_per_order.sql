SELECT
	COUNT(*) AS total_quantity
FROM
	Invoices
WHERE
	unit_price > 0
	AND quantity > 0
GROUP BY 
	invoice_no;
	
GO