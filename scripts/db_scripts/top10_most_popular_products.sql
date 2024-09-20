SELECT
    TOP 10
	description,
	SUM(quantity) AS total_units_sold
FROM
	Invoices
GROUP BY
	description
ORDER BY	
	total_units_sold DESC;

GO