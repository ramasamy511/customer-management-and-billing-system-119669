-- Customer Management & Billing System: MySQL Initial Schema

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE IF NOT EXISTS Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(12,2) NOT NULL,
    sku VARCHAR(100) UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Invoices Table
CREATE TABLE IF NOT EXISTS Invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE,
    status ENUM('draft','issued','paid','partially_paid','overdue','cancelled') DEFAULT 'issued',
    total_amount DECIMAL(12,2) NOT NULL,
    balance_due DECIMAL(12,2) NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_status (status)
);

-- InvoiceItems Table
CREATE TABLE IF NOT EXISTS InvoiceItems (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    description TEXT,
    quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(12,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE SET NULL,
    INDEX idx_invoice_id (invoice_id)
);

-- Payments Table
CREATE TABLE IF NOT EXISTS Payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    payment_date DATE NOT NULL,
    method ENUM('cash','card','bank_transfer','upi','cheque','other') DEFAULT 'cash',
    amount DECIMAL(12,2) NOT NULL,
    reference VARCHAR(255),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(id) ON DELETE CASCADE,
    INDEX idx_method (method)
);

-- Reminders Table
CREATE TABLE IF NOT EXISTS Reminders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    customer_id INT NOT NULL,
    reminder_date DATE NOT NULL,
    reminder_type ENUM('email','whatsapp','sms') NOT NULL,
    status ENUM('pending','sent','failed') DEFAULT 'pending',
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(id) ON DELETE CASCADE,
    INDEX idx_reminder_date (reminder_date)
);

-- Analytics: Frequent Purchases
CREATE TABLE IF NOT EXISTS FrequentPurchases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    purchase_count INT NOT NULL DEFAULT 0,
    last_purchased DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    UNIQUE KEY uq_customer_product (customer_id, product_id)
);

-- Analytics: Customer Balances (for analytic views)
CREATE TABLE IF NOT EXISTS CustomerBalances (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    outstanding_amount DECIMAL(12,2) NOT NULL,
    last_invoice_date DATE,
    last_payment_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(id) ON DELETE CASCADE,
    UNIQUE KEY uq_customer (customer_id)
);

-- Analytics: TopProducts
CREATE TABLE IF NOT EXISTS TopProducts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    times_sold INT NOT NULL DEFAULT 0,
    total_revenue DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    UNIQUE KEY uq_product (product_id)
);

-- Index for fast outstanding/invoice search
CREATE INDEX idx_invoices_customer_date ON Invoices(customer_id, invoice_date);

-- Additional indices for analytics tables
CREATE INDEX idx_fp_customer ON FrequentPurchases(customer_id);
CREATE INDEX idx_fp_product ON FrequentPurchases(product_id);

-- End of schema
