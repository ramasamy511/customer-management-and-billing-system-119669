#!/bin/bash

# PostgreSQL setup script for customer-management-billing system

DB_NAME="myapp"
DB_USER="appuser"
DB_PASSWORD="dbuser123"
DB_PORT="5432"

echo "Starting PostgreSQL setup..."

# Check for psql
if ! command -v psql > /dev/null; then
  echo "psql command not found. Please install PostgreSQL client/server packages."
  exit 1
fi

# Try to connect and create DB/user if needed
echo "Creating database and user (if not exists)..."
psql -U postgres -h localhost -p $DB_PORT -c "CREATE DATABASE $DB_NAME;" 2>/dev/null || echo "Database may already exist."
psql -U postgres -h localhost -p $DB_PORT -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || echo "User may already exist."
psql -U postgres -h localhost -p $DB_PORT -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" 2>/dev/null

# Import schema
echo "Importing schema..."
psql -U $DB_USER -h localhost -p $DB_PORT -d $DB_NAME -f ./core_schema_postgresql.sql

echo "Done."
echo "To connect:"
echo "  psql postgresql://$DB_USER:$DB_PASSWORD@localhost:$DB_PORT/$DB_NAME"
echo "To use with Node.js db visualizer, run:"
echo "  source db_visualizer/postgres.env"
