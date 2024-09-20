SELECT
	TOP 5
	description,
	SUM(quantity) AS total_quantity
FROM
	Invoices i
JOIN
	customer_segmentation c
ON
	i.customer_id = c.customer_id
WHERE
	customer_group = 'Medium Spender'
GROUP BY
	description
ORDER BY 
	total_quantity DESC;
	
GO