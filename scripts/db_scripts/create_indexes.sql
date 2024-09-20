-- Index on country column in Countries table
CREATE INDEX idx_country_name 
ON Countries(country);

-- Single-column indexes for Invoices table
CREATE INDEX idx_invoice_no
ON Invoices(invoice_no);

CREATE INDEX idx_description
ON Invoices(description);

CREATE INDEX idx_quantity_unit_price
ON Invoices(quantity, unit_price);

CREATE INDEX idx_customer_id
ON Invoices(customer_id);

CREATE INDEX idx_invoice_date
ON Invoices(invoice_date);