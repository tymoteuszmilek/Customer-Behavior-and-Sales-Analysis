-- Drop the database if it exists and create a new one
DROP DATABASE IF EXISTS CustomerSales;
GO

CREATE DATABASE CustomerSales;
GO

USE CustomerSales;
GO

BEGIN TRANSACTION;

-- Drop temporary table if exists
DROP TABLE IF EXISTS OnlineRetail;

-- Create a temporary table to load data
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

-- Insert data from CSV file into the temporary table
BULK INSERT OnlineRetail
FROM '/var/opt/mssql/cleanedData/Online Retail.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

COMMIT TRANSACTION;

-- Create and populate final tables
BEGIN TRANSACTION;

-- Drop tables if they exist
DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS Countries;

-- Create the Countries table
CREATE TABLE Countries (
    country_id INTEGER PRIMARY KEY IDENTITY(1,1),
    country NVARCHAR(100) UNIQUE
);

-- Insert distinct countries into the Countries table
INSERT INTO Countries (country)
SELECT DISTINCT country
FROM OnlineRetail;

-- Create the Invoices table
CREATE TABLE Invoices (
    retail_id INTEGER PRIMARY KEY IDENTITY(1,1),
    invoice_no NVARCHAR(50),
    stock_code NVARCHAR(50),
    description NVARCHAR(300),
    quantity INTEGER,
    unit_price DECIMAL(10,2),
    invoice_date DATETIME,
    customer_id INTEGER,
    country_id INTEGER,
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

-- Insert data into the Invoices table
INSERT INTO Invoices (invoice_no, stock_code, description, quantity, unit_price, invoice_date, customer_id, country_id)
SELECT
    o.invoice_no,
    o.stock_code,
    o.description,
    o.quantity,
    o.unit_price,
    o.invoice_date,
    o.customer_id,
    c.country_id
FROM
    OnlineRetail o
JOIN
    Countries c ON c.country = o.country;

-- Drop the temporary table
DROP TABLE IF EXISTS OnlineRetail;

COMMIT TRANSACTION;

-- Create indexes
CREATE INDEX idx_country_name 
ON Countries(country);

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

-- Drop and recreate the view
DROP VIEW IF EXISTS customer_segmentation;
GO

CREATE VIEW customer_segmentation AS
WITH total_spending_per_customer AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM
        Invoices
    GROUP BY
        customer_id
),
customer_groups AS (
    SELECT 
        customer_id,
        total_amount,
        CASE
            WHEN total_amount >= 1600 THEN 'High Spender'
            WHEN total_amount >= 650 THEN 'Medium Spender'
            ELSE 'Low Spender'
        END AS customer_group
    FROM
        total_spending_per_customer
)
SELECT * FROM customer_groups;

GO
