BEGIN TRANSACTION;

DROP TABLE IF EXISTS OnlineRetail;

-- TEMP table
CREATE TABLE OnlineRetail (
	invoice_no NVARCHAR(50),
	stock_code NVARCHAR(50),
	description NVARCHAR(300),
	quantity INTEGER,
	invoice_date DATETIME,
	unit_price DECIMAL(10,2),
	customer_id INTEGER,
	country NVARCHAR(100),
	retail_id INTEGER
);

-- INSERT CSV file into TEMP table
BULK INSERT OnlineRetail
FROM '/var/opt/mssql/cleanedData/Online Retail.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

COMMIT TRANSACTION;
