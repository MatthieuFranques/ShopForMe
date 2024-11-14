#!/bin/sh

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Wait for the database to be ready
echo "Waiting for database to be ready..."
until nc -z -v -w30 db 5432
do
  echo "Waiting for postgres database connection..."
  sleep 1
done

# Run Prisma migrations or push
npx prisma db push

# Execute the main container command
exec "$@"
