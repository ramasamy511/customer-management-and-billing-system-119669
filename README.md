# Project Repository

This is the initial README file for the project.

## PostgreSQL Database Schema

The core normalized tables for the Customer Management & Billing System are defined in
`database_postgresql/core_schema_postgresql.sql`.

### Key entities:

- customers
- products
- invoices (with invoice_line_items)
- payments
- analytics_snapshot (for reporting)
- data_change_log (audit, optional)

### Local Usage

- Use `database_postgresql/startup_postgres.sh` to initialize the DB (requires PostgreSQL).
- Connection string example:
  ```
  psql postgresql://appuser:dbuser123@localhost:5432/myapp
  ```
- Environment file: `database_postgresql/db_visualizer/postgres.env`

### Switching from MySQL to PostgreSQL

- Ensure backend applications use `POSTGRES_*` environment variables.
- The Node.js db visualizer supports both MySQL and PostgreSQL; activate PostgreSQL by sourcing `postgres.env`.
