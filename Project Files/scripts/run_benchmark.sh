
#!/bin/bash

# Get the username and database from arguments
DB_USER=$1
DB_NAME=$2

# Set file paths
SCRIPTS_DIR=$(dirname "$0")
OUTPUT_DIR="$SCRIPTS_DIR/output"
QUERY_FILE="$SCRIPTS_DIR/test_queries.sql"
INDEX_FILE="$SCRIPTS_DIR/ddl_indexes.sql"
ANALYZE_FILE="$SCRIPTS_DIR/analyze_tables.sql"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Split test_queries.sql into separate query files
awk -v n=0 '/-- Query/{n++; close(out); out="./query"n".sql"} {print > out}' "$QUERY_FILE"

# Check if the queries were split correctly
for i in {1..9}; do
    if [ ! -f "./query$i.sql" ]; then
        echo "Query file ./query$i.sql not found."
        exit 1
    fi
done

# Run each query under different conditions
for i in {1..9}; do
    QUERY_FILE="./query$i.sql"

    # Remove EXPLAIN ANALYZE from the query before running it
    CLEANED_QUERY_FILE="$SCRIPTS_DIR/query${i}_without_explain.sql"
    sed '/EXPLAIN ANALYZE/d' "$QUERY_FILE" > "$CLEANED_QUERY_FILE"

    # Run the query without EXPLAIN ANALYZE and save the raw result
    echo "Running query $i (without EXPLAIN ANALYZE) and saving the raw result..."

    OUTPUT_FILE="$OUTPUT_DIR/query${i}_raw_output.txt"

    if [ "$i" -eq 3 ]; then
        # Ensure column names are included for Query 3
        psql -U "$DB_USER" -d "$DB_NAME" -f "$CLEANED_QUERY_FILE" --pset footer=off > "$OUTPUT_FILE"
    elif [ "$i" -eq 5 ]; then
        # Use expanded output mode for Query 5
        psql -U "$DB_USER" -d "$DB_NAME" -f "$CLEANED_QUERY_FILE" -x --pset footer=off > "$OUTPUT_FILE"
    else
        # Default for other queries
        psql -U "$DB_USER" -d "$DB_NAME" -f "$CLEANED_QUERY_FILE" --pset footer=off > "$OUTPUT_FILE"
    fi

    echo "Raw output for query $i saved to $OUTPUT_FILE."

    # Run without statistics or indexes (original query)
    echo "Running query $i without statistics or indexes (EXPLAIN ANALYZE)..."
    psql -U "$DB_USER" -d "$DB_NAME" -f "$QUERY_FILE" > "$OUTPUT_DIR/query${i}_without_stats_indexes.txt"

    # Run ANALYZE to collect table statistics
    echo "Collecting table statistics with ANALYZE for query $i..."
    #psql -U "$DB_USER" -d "$DB_NAME" -f "$ANALYZE_FILE" > "$OUTPUT_DIR/query${i}_analyze_output.txt"

    # Run with statistics but without indexes
    echo "Running query $i with statistics but without indexes..."
    psql -U "$DB_USER" -d "$DB_NAME" -f "$QUERY_FILE" > "$OUTPUT_DIR/query${i}_with_stats_no_indexes.txt"

    # Create indexes
    echo "Creating indexes for query $i..."
    #psql -U "$DB_USER" -d "$DB_NAME" -f "$INDEX_FILE" > "$OUTPUT_DIR/query${i}_create_indexes_output.txt"

    # Run with statistics and indexes
    echo "Running query $i with statistics and indexes..."
    psql -U "$DB_USER" -d "$DB_NAME" -f "$QUERY_FILE" > "$OUTPUT_DIR/query${i}_with_stats_and_indexes.txt"
done

# Summarize results
echo "Benchmarking completed. Results saved in $OUTPUT_DIR."

# Display output files
echo "Outputs:"
for i in {1..9}; do
    echo "Query $i:"
    echo "1. Without stats or indexes: $OUTPUT_DIR/query${i}_without_stats_indexes.txt"
    echo "2. With stats but no indexes: $OUTPUT_DIR/query${i}_with_stats_no_indexes.txt"
    echo "3. With stats and indexes: $OUTPUT_DIR/query${i}_with_stats_and_indexes.txt"
    echo "4. Raw output (as .txt): $OUTPUT_DIR/query${i}_raw_output.txt"
done

# Generate Visualization 1
echo "Generating first visualization..."
python "$SCRIPTS_DIR/visualize_benchmark.py"

# Check if the first visualization script was successful
if [ $? -eq 0 ]; then
    echo "First visualization generated successfully."
else
    echo "Error generating first visualization."
    exit 1
fi

# Generate Visualization 2
echo "Generating second visualization..."
python "$SCRIPTS_DIR/visualize_benchmark_planning_execution.py"

# Check if the second visualization script was successful
if [ $? -eq 0 ]; then
    echo "Second visualization generated successfully."
else
    echo "Error generating second visualization."
    exit 1
fi
