
import re
import matplotlib.pyplot as plt  # type: ignore
from pathlib import Path
import numpy as np # type: ignore

# Resolve base directory dynamically
base_dir = Path(__file__).resolve().parent
output_dir = base_dir / "output"

# Define conditions
conditions = ['without_stats_indexes', 'with_stats_no_indexes', 'with_stats_and_indexes']

# Initialize execution times for 9 queries
execution_times = {f"Query {i}": [None] * len(conditions) for i in range(1, 10)}  # Change 8 to 9

# Extract execution times for all queries under all conditions
for query_num in range(1, 10):  # Loop through queries 1 to 9 (inclusive)
    for condition_idx, condition in enumerate(conditions):
        file_name = f"query{query_num}_{condition}.txt"
        file_path = output_dir / file_name
        if file_path.is_file():
            print(f"Processing file: {file_path}")  # Debugging log
            with open(file_path, 'r') as file:
                content = file.read()
                match = re.search(r"Execution Time: ([\d\.]+) ms", content)
                if match:
                    execution_times[f"Query {query_num}"][condition_idx] = float(match.group(1))
                else:
                    print(f"No execution time found in {file_path}")
        else:
            print(f"Error: File {file_path} not found.")

# Ensure there is data to visualize
if not any(any(times) for times in execution_times.values()):
    print("No execution times extracted. Check your benchmark outputs.")
    exit(1)

# Replace missing data (None) with 0.0
for query in execution_times:
    execution_times[query] = [time if time is not None else 0.0 for time in execution_times[query]]

# Prepare the data for plotting
queries = list(execution_times.keys())
times = np.array([execution_times[query] for query in queries])

# Set positions for each group of bars (one group per query)
bar_width = 0.2  # Width of each bar
index = np.arange(len(queries))  # Position of each group on the x-axis

# Define the colors for the bars (three bars per group)
colors = ['blue', 'orange', 'green']

# Create the plot
plt.figure(figsize=(16, 10))  

# Plot bars for each query (3 bars per query)
for i, query in enumerate(queries):
    # Plot bars without legend for the first query only
    if i == 0:
        plt.bar(index[i] - bar_width, times[i][0], bar_width, color=colors[0])
        plt.bar(index[i], times[i][1], bar_width, color=colors[1])
        plt.bar(index[i] + bar_width, times[i][2], bar_width, color=colors[2])
    else:
        # Add legend labels for subsequent queries
        plt.bar(index[i] - bar_width, times[i][0], bar_width, color=colors[0], label="Without Stats or Indexes" if i == 1 else "")
        plt.bar(index[i], times[i][1], bar_width, color=colors[1], label="With Stats No Indexes" if i == 1 else "")
        plt.bar(index[i] + bar_width, times[i][2], bar_width, color=colors[2], label="With Stats and Indexes" if i == 1 else "")

# Add labels and title
plt.title('Query Execution Times by Query and Condition', fontsize=16)
plt.xlabel('Queries', fontsize=12)
plt.ylabel('Execution Time (ms)', fontsize=12)
plt.xticks(index, queries, fontsize=12)
plt.yticks(fontsize=12)

# Display the legend only once
plt.legend(loc='upper left', fontsize=10, bbox_to_anchor=(1, 1))

# Tight layout to avoid overlap
plt.tight_layout()

# Save the chart
chart_path = output_dir / "query_execution_times_grouped.png"
plt.savefig(chart_path)
plt.close()

print(f"Chart saved at {chart_path}")
