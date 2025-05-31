-- 03_foreign_keys.sql
-- Adds foreign key constraints to the tables.
-- Run this script after tables are created (01_schema_creation.sql) 
-- and data is ingested (02_data_ingestion.sql).

-- Foreign key for events table
ALTER TABLE public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE NO ACTION;

-- Foreign key for orders table
ALTER TABLE public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE NO ACTION;

-- Foreign key for products table
ALTER TABLE public.products
    ADD CONSTRAINT products_distribution_center_id_fkey FOREIGN KEY (distribution_center_id) REFERENCES public.distribution_centers(id) ON DELETE NO ACTION;

-- Foreign keys for inventory_items table
ALTER TABLE public.inventory_items
    ADD CONSTRAINT inventory_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE NO ACTION,
    ADD CONSTRAINT inventory_items_product_distribution_center_id_fkey FOREIGN KEY (product_distribution_center_id) REFERENCES public.distribution_centers(id) ON DELETE NO ACTION;

-- Foreign keys for order_items table
ALTER TABLE public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE NO ACTION,
    ADD CONSTRAINT order_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE NO ACTION,
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE NO ACTION,
    ADD CONSTRAINT order_items_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id) ON DELETE NO ACTION;
