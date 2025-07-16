-- CUSTOMER MANAGEMENT & BILLING SYSTEM (PostgreSQL)
-- Core normalized schema: customers, products, invoices, invoice_line_items, payments, analytics_snapshot

-- 1. CUSTOMERS table: stores master customer information
CREATE TABLE IF NOT EXISTS customers (
    customer_id      SERIAL PRIMARY KEY,
    customer_code    VARCHAR(32)  UNIQUE NOT NULL,
    name             VARCHAR(128) NOT NULL,
    email            VARCHAR(128),
    phone            VARCHAR(32),
    address          TEXT,
    gst_number       VARCHAR(32),
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_customers_name ON customers (name);
CREATE INDEX idx_customers_email ON customers (email);

-- 2. PRODUCTS table: stores product master data
CREATE TABLE IF NOT EXISTS products (
    product_id       SERIAL PRIMARY KEY,
    product_code     VARCHAR(32)  UNIQUE NOT NULL,
    name             VARCHAR(128) NOT NULL,
    description      TEXT,
    unit_price       NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_name ON products (name);

-- 3. INVOICES table: header for each sales invoice
CREATE TABLE IF NOT EXISTS invoices (
    invoice_id       SERIAL PRIMARY KEY,
    invoice_number   VARCHAR(32) UNIQUE NOT NULL,
    customer_id      INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    invoice_date     DATE NOT NULL,
    due_date         DATE,
    total_amount     NUMERIC(14, 2) NOT NULL DEFAULT 0,
    status           VARCHAR(24) NOT NULL DEFAULT 'unpaid',
    remarks          TEXT,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invoices_customer_id ON invoices (customer_id);
CREATE INDEX idx_invoices_status ON invoices (status);

-- 4. INVOICE_LINE_ITEMS: details for each product in invoice
CREATE TABLE IF NOT EXISTS invoice_line_items (
    line_item_id     SERIAL PRIMARY KEY,
    invoice_id       INTEGER NOT NULL REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    product_id       INTEGER NOT NULL REFERENCES products(product_id),
    description      TEXT,
    quantity         NUMERIC(14, 2) NOT NULL CHECK (quantity > 0),
    unit_price       NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    line_total       NUMERIC(14, 2) NOT NULL GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE INDEX idx_invoice_line_items_invoice_id ON invoice_line_items (invoice_id);
CREATE INDEX idx_invoice_line_items_product_id ON invoice_line_items (product_id);

-- 5. PAYMENTS: records of customer payments
CREATE TABLE IF NOT EXISTS payments (
    payment_id       SERIAL PRIMARY KEY,
    customer_id      INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    invoice_id       INTEGER REFERENCES invoices(invoice_id) ON DELETE SET NULL,
    payment_date     DATE NOT NULL,
    amount           NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    payment_mode     VARCHAR(32) NOT NULL, -- e.g. cash, card, bank, UPI, cheque
    ref_number       VARCHAR(64),
    notes            TEXT,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_customer_id ON payments (customer_id);
CREATE INDEX idx_payments_invoice_id ON payments (invoice_id);
CREATE INDEX idx_payments_date ON payments (payment_date);

-- 6. Analytics snapshot (aggregated/statistics view for dashboards)
-- Used for periodic/statistical reporting, not for transactional data
CREATE TABLE IF NOT EXISTS analytics_snapshot (
    snapshot_id      SERIAL PRIMARY KEY,
    snapshot_at      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    outstanding_customers INTEGER,
    total_sales      NUMERIC(18, 2),
    total_payments   NUMERIC(18, 2),
    top_product_id   INTEGER REFERENCES products(product_id),
    top_customer_id  INTEGER REFERENCES customers(customer_id),
    best_buyer_id    INTEGER REFERENCES customers(customer_id),
    frequent_product_id INTEGER REFERENCES products(product_id),
    report_json      JSONB
);

-- Legacy/utility: audit logs for future-proofing (optional)
CREATE TABLE IF NOT EXISTS data_change_log (
    log_id           SERIAL PRIMARY KEY,
    table_name       VARCHAR(64) NOT NULL,
    row_id           INTEGER     NOT NULL,
    operation        VARCHAR(16) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    change_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    user_info        VARCHAR(128),
    change_details   JSONB
);

-- Sample unique constraint and check for invoice line
ALTER TABLE invoice_line_items
    ADD CONSTRAINT uniq_invoice_product UNIQUE (invoice_id, product_id)
    ;

-- Future index examples for analytics/dashboard queries
-- CREATE INDEX idx_payments_invoice_customer ON payments (invoice_id, customer_id);
"````

Explanation: Add PostgreSQL environment variables and config in a .env file for local setup/use by other services.
````write file="customer-management-and-billing-system-119669/database_postgresql/db_visualizer/postgres.env"
export POSTGRES_URL="postgresql://localhost:5432/myapp"
export POSTGRES_USER="appuser"
export POSTGRES_PASSWORD="dbuser123"
export POSTGRES_DB="myapp"
export POSTGRES_PORT="5432"
