-- CREATE tables / INSERT values
BEGIN TRANSACTION;

DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS Countries;

CREATE TABLE Countries (
    country_id INTEGER PRIMARY KEY IDENTITY(1,1),
    country NVARCHAR(100) UNIQUE
);

-- Insert distinct countries into the Countries table
INSERT INTO Countries (country)
SELECT DISTINCT country
FROM OnlineRetail;


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

-- Insert data into the Invoices table, joining with Countries to get the country_id
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

-- Drop the original OnlineRetail (temporary) table
DROP TABLE IF EXISTS OnlineRetail;

COMMIT TRANSACTION;
