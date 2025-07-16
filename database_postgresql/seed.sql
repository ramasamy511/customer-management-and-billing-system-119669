-- PostgreSQL-compatible Seed Data for Customer Management & Billing System

-- Truncate all tables first (for repeatable demo data import)
TRUNCATE TABLE
    FrequentPurchases,
    CustomerBalances,
    TopProducts,
    Reminders,
    Payments,
    InvoiceItems,
    Invoices,
    Products,
    Customers
RESTART IDENTITY CASCADE;

-- Customers
INSERT INTO Customers (name, email, phone, address, created_at, updated_at) VALUES
('Alice Johnson', 'alice.j@example.com', '+1234567890', '123 Apple Street, Cupertino', NOW(), NOW()),
('Bob Smith', 'bob.smith@example.net', '+1987654321', '456 Orange Ave, Sunnyvale', NOW(), NOW()),
('Cathy Lee', 'cathy.lee@example.org', NULL, '789 Banana Blvd, Mountain View', NOW(), NOW());

-- Products
INSERT INTO Products (name, description, price, sku, created_at, updated_at) VALUES
('Website Design', 'Full website design services for small businesses', 1500.00, 'PROD-WD-001', NOW(), NOW()),
('Cloud Hosting', 'Annual cloud hosting subscription', 400.00, 'PROD-CH-002', NOW(), NOW()),
('SEO Package', 'SEO optimization services, includes monthly reports', 500.00, 'PROD-SEO-003', NOW(), NOW()),
('Digital Marketing', 'Monthly digital marketing campaign', 700.00, 'PROD-DM-004', NOW(), NOW());

-- Invoices
INSERT INTO Invoices (customer_id, invoice_date, due_date, status, total_amount, balance_due, notes, created_at, updated_at) VALUES
(1, NOW() - INTERVAL '30 days', NOW() - INTERVAL '10 days', 'paid', 1500.00, 0.00, 'Website launch project', NOW(), NOW()),
(2, NOW() - INTERVAL '20 days', NOW() - INTERVAL '5 days', 'overdue', 900.00, 500.00, 'Annual hosting + SEO', NOW(), NOW()),
(3, NOW() - INTERVAL '10 days', NOW() + INTERVAL '20 days', 'issued', 700.00, 700.00, 'First digital marketing cycle', NOW(), NOW());

-- InvoiceItems
INSERT INTO InvoiceItems (invoice_id, product_id, description, quantity, unit_price, total_price) VALUES
(1, 1, 'Website Design for Alice', 1, 1500.00, 1500.00),
(2, 2, 'Cloud hosting for Bob', 1, 400.00, 400.00),
(2, 3, 'SEO first month for Bob', 1, 500.00, 500.00),
(3, 4, 'Digital Marketing for Cathy', 1, 700.00, 700.00);

-- Payments
INSERT INTO Payments (invoice_id, payment_date, method, amount, reference, notes, created_at) VALUES
(1, NOW() - INTERVAL '9 days', 'bank_transfer', 1500.00, 'TRX123456', 'Full payment received', NOW() - INTERVAL '9 days'),
(2, NOW() - INTERVAL '3 days', 'upi', 400.00, 'UPI-BOBSMITH', 'Partial payment', NOW() - INTERVAL '3 days');

-- Reminders
INSERT INTO Reminders (invoice_id, customer_id, reminder_date, reminder_type, status, message, created_at) VALUES
(2, 2, NOW() - INTERVAL '4 days', 'email', 'sent', 'Dear Bob, your payment is overdue.', NOW() - INTERVAL '4 days'),
(2, 2, NOW() - INTERVAL '1 days', 'sms', 'pending', 'Reminder: Please pay the remaining invoice.', NOW() - INTERVAL '1 days'),
(3, 3, NOW(), 'whatsapp', 'pending', 'Upcoming invoice for your Digital Marketing services.', NOW());

-- FrequentPurchases (Analytics)
INSERT INTO FrequentPurchases (customer_id, product_id, purchase_count, last_purchased)
VALUES
(1, 1, 1, NOW() - INTERVAL '9 days'),
(2, 2, 3, NOW() - INTERVAL '3 days'),
(2, 3, 1, NOW() - INTERVAL '3 days'),
(3, 4, 1, NOW());

-- CustomerBalances (Analytics)
INSERT INTO CustomerBalances (customer_id, outstanding_amount, last_invoice_date, last_payment_date)
VALUES
(1, 0.00, NOW() - INTERVAL '30 days', NOW() - INTERVAL '9 days'),
(2, 500.00, NOW() - INTERVAL '20 days', NOW() - INTERVAL '3 days'),
(3, 700.00, NOW() - INTERVAL '10 days', NULL);

-- TopProducts (Analytics)
INSERT INTO TopProducts (product_id, times_sold, total_revenue)
VALUES
(1, 1, 1500.00),
(2, 3, 1200.00),
(3, 1, 500.00),
(4, 1, 700.00);

-- End of seed.sql
