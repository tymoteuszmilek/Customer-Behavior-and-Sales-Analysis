SELECT 
    customer_id,
    SUM(quantity * unit_price) AS total_amount
FROM    
    Invoices
GROUP BY 
    customer_id
ORDER BY 
    total_amount DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

GO