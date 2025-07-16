FROM postgres:14

# Set default schema and seed location
ENV POSTGRES_DB=customerdb
ENV POSTGRES_USER=customeruser
ENV POSTGRES_PASSWORD=customerpass

# Copy schema and seed files
COPY schema.sql /docker-entrypoint-initdb.d/1-schema.sql
COPY seed.sql /docker-entrypoint-initdb.d/2-seed.sql

# Add startup hooks or custom scripts if needed (optional)
# COPY startup.sh /docker-entrypoint-initdb.d/99-startup.sh
