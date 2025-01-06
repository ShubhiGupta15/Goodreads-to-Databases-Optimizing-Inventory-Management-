

#!/bin/bash

# Get the script's current directory (to make paths relative)
BASE_DIR=$(dirname "$0")/..

# Define paths to the SQL file and data folder
SQL_FILE="$BASE_DIR/scripts/ddl_schema.sql"
DATA_DIR="$BASE_DIR/data"

# Prompt for database connection details if not provided as arguments
if [ -z "$1" ]; then
  read -p "Enter PostgreSQL username: " DB_USER
else
  DB_USER="$1"
fi

if [ -z "$2" ]; then
  read -p "Enter database name: " DB_NAME
else
  DB_NAME="$2"
fi

# Change to the correct directory for relative paths
cd "$BASE_DIR/scripts"

# Run the SQL file using psql
psql -U "$DB_USER" -d "$DB_NAME" -f "$SQL_FILE"

# Run the second script (indexes.sh) and pass credentials as arguments
./run_benchmark.sh "$DB_USER" "$DB_NAME"
