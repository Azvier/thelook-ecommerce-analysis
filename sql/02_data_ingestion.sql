-- 02_data_ingestion.sql
-- Imports data from CSV files into their respective tables.
-- Ensure tables are created (by running 01_schema_creation.sql) before running this.
-- Ensure CSV files are accessible at '/mnt/data_raw/' inside PostgreSQL Docker container.

COPY users 
FROM '/mnt/data_raw/users.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');

COPY distribution_centers 
FROM '/mnt/data_raw/distribution_centers.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');

COPY events 
FROM '/mnt/data_raw/events.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');

COPY orders 
FROM '/mnt/data_raw/orders.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');

COPY products 
FROM '/mnt/data_raw/products.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');

COPY inventory_items 
FROM '/mnt/data_raw/inventory_items.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');

COPY order_items 
FROM '/mnt/data_raw/order_items.csv' 
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', NULL '');
