# Database (PostgreSQL) - Packaging/Deployment

## Local Instantiation (Without Docker)
- Ensure PostgreSQL is installed.
- Create database and user matching your `.env` or app settings.
- Run:
    ```
    psql -U <user> -d <db> -f schema.sql
    psql -U <user> -d <db> -f seed.sql
    ```

## Containerized Setup

### Simple Run
```
docker build -t customer-db .
docker run -e POSTGRES_USER=customeruser -e POSTGRES_PASSWORD=customerpass -e POSTGRES_DB=customerdb -p 5432:5432 customer-db
```
Schema and seed are loaded on first launch.

### Compose Usage
Use within `docker-compose.yml` with `volumes` if persistent data is required.

## Files
- `schema.sql` — Complete DB schema.
- `seed.sql` — Sample or initial data to populate tables.

Change `ENV` in Dockerfile or override with `docker run -e ...` for real deployments.
