WITH total_amount AS (
SELECT
	SUM(quantity * unit_price) as total
FROM	
	Invoices
)
SELECT
	country,
	CAST(ROUND(SUM(quantity * unit_price) * 100 / total,2) AS DECIMAL(4,2))AS percentage
FROM
	Invoices i
JOIN
	Countries c
ON
	c.country_id = i.country_id
	
CROSS JOIN
	total_amount
GROUP BY 
	country,total
ORDER BY 
	percentage DESC;
	
GO