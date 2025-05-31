-- 01_schema_creation.sql
-- Creates table structures with columns, data types, and primary keys.

-- Drop tables if they exist to ensure a clean slate (optional, use with caution)
DROP TABLE IF EXISTS public.order_items;
DROP TABLE IF EXISTS public.inventory_items;
DROP TABLE IF EXISTS public.products;
DROP TABLE IF EXISTS public.orders;
DROP TABLE IF EXISTS public.events;
DROP TABLE IF EXISTS public.distribution_centers;
DROP TABLE IF EXISTS public.users;

-- Create users table
CREATE TABLE public.users (
    id INT4 NOT NULL,
    first_name VARCHAR(50) NULL,
    last_name VARCHAR(50) NULL,
    email VARCHAR(255) NULL,
    age INT4 NULL,
    gender VARCHAR(1) NULL,
    state VARCHAR(50) NULL,
    street_address VARCHAR(255) NULL,
    postal_code VARCHAR(50) NULL,
    city VARCHAR(50) NULL,
    country VARCHAR(50) NULL,
    latitude FLOAT4 NULL, 
    longitude FLOAT4 NULL, 
    traffic_source VARCHAR(50) NULL,
    created_at TIMESTAMPTZ NULL,
    user_geom VARCHAR(50) NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id)
);

-- Create distribution_centers table
CREATE TABLE public.distribution_centers (
    id INT4 NOT NULL,
    name VARCHAR(50) NULL,
    latitude FLOAT4 NULL, 
    longitude FLOAT4 NULL, 
    distribution_center_geom VARCHAR(50) NULL,
    CONSTRAINT distribution_centers_pkey PRIMARY KEY (id)
);

-- Create events table
CREATE TABLE public.events (
    id INT4 NOT NULL,
    user_id INT4 NULL, -- Foreign key will be added later
    sequence_number INTEGER NULL,
    session_id VARCHAR(50) NULL,
    created_at TIMESTAMPTZ NULL,
    ip_address VARCHAR(50) NULL,
    city VARCHAR(50) NULL,
    state VARCHAR(50) NULL,
    postal_code VARCHAR(50) NULL,
    browser VARCHAR(50) NULL,
    traffic_source VARCHAR(50) NULL,
    uri VARCHAR(1000) NULL,
    event_type VARCHAR(50) NULL,
    CONSTRAINT events_pkey PRIMARY KEY (id)
);

-- Create orders table
CREATE TABLE public.orders (
    order_id INT4 NOT NULL,
    user_id INT4 NULL, -- Foreign key will be added later
    status VARCHAR(50) NULL,
    gender VARCHAR(1) NULL,
    created_at TIMESTAMPTZ NULL,
    returned_at TIMESTAMPTZ NULL,
    shipped_at TIMESTAMPTZ NULL,
    delivered_at TIMESTAMPTZ NULL,
    num_of_item INT4 NULL,
    CONSTRAINT orders_pkey PRIMARY KEY (order_id)
);

-- Create products table
CREATE TABLE public.products (
    id INT4 NOT NULL,
    cost NUMERIC(20, 16) NULL,
    category VARCHAR(50) NULL,
    name VARCHAR(255) NULL,
    brand VARCHAR(50) NULL,
    retail_price NUMERIC(20, 16) NULL,
    department VARCHAR(50) NULL,
    sku VARCHAR(50) NULL,
    distribution_center_id INT4 NULL, -- Foreign key will be added later
    CONSTRAINT products_pkey PRIMARY KEY (id)
);

-- Create inventory_items table
CREATE TABLE public.inventory_items (
    id INT4 NOT NULL,
    product_id INT4 NULL, -- Foreign key will be added later
    created_at TIMESTAMPTZ NULL,
    sold_at TIMESTAMPTZ NULL,
    cost NUMERIC(20, 16) NULL,
    product_category VARCHAR(50) NULL,
    product_name VARCHAR(255) NULL,
    product_brand VARCHAR(50) NULL,
    product_retail_price NUMERIC(20, 16) NULL,
    product_department VARCHAR(50) NULL,
    product_sku VARCHAR(50) NULL,
    product_distribution_center_id INT4 NULL, -- Foreign key will be added later
    CONSTRAINT inventory_items_pkey PRIMARY KEY (id)
);

-- Create order_items table
CREATE TABLE public.order_items (
    id INT4 NOT NULL,
    order_id INT4 NULL, -- Foreign key will be added later
    user_id INT4 NULL, -- Foreign key will be added later
    product_id INT4 NULL, -- Foreign key will be added later
    inventory_item_id INT4 NULL, -- Foreign key will be added later
    status VARCHAR(50) NULL,
    created_at TIMESTAMPTZ NULL,
    shipped_at TIMESTAMPTZ NULL,
    delivered_at TIMESTAMPTZ NULL,
    returned_at TIMESTAMPTZ NULL,
    sale_price NUMERIC(20, 16) NULL,
    CONSTRAINT order_items_pkey PRIMARY KEY (id)
);