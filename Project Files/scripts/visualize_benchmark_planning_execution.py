

import re
import matplotlib.pyplot as plt  # type: ignore
import os

# Get the current script directory (absolute path)
scripts_dir = os.path.dirname(os.path.realpath(__file__))
output_dir = os.path.join(scripts_dir, "output")

# Extend the files dictionary for 9 queries 
files = {f"Query {i}": {
            "Without Stats or Indexes": os.path.join(output_dir, f"query{i}_without_stats_indexes.txt"),
            "With Stats but No Indexes": os.path.join(output_dir, f"query{i}_with_stats_no_indexes.txt"),
            "With Stats and Indexes": os.path.join(output_dir, f"query{i}_with_stats_and_indexes.txt")
         } for i in range(1, 10)} 

# Extract Planning and Execution Times
results = {}
for query, conditions in files.items():
    results[query] = {}
    for condition, file_path in conditions.items():
        try:
            with open(file_path, 'r') as file:
                content = file.read()
                # Extract Planning and Execution Times
                planning_time = re.search(r"Planning Time: ([\d.]+) ms", content)
                execution_time = re.search(r"Execution Time: ([\d.]+) ms", content)
                if planning_time and execution_time:
                    results[query][condition] = {
                        "Planning Time (ms)": float(planning_time.group(1)),
                        "Execution Time (ms)": float(execution_time.group(1))
                    }
                else:
                    print(f"No timing data found in {file_path}")
        except FileNotFoundError:
            print(f"File not found: {file_path}")
            results[query][condition] = {
                "Planning Time (ms)": 0.0,
                "Execution Time (ms)": 0.0
            }

# If no results were found, exit early
if not results:
    print("No results to display. Exiting.")
    exit()

# Prepare data for visualization
scenarios = ["Without Stats or Indexes", "With Stats but No Indexes", "With Stats and Indexes"]

# Define colors for each bar
planning_color = 'skyblue'
execution_color = 'orange'

# Bar width
bar_width = 0.2

# Plot separate charts for each query
for query in results:
    # Prepare data for each query
    planning_times = [results[query].get(scenario, {"Planning Time (ms)": 0.0})["Planning Time (ms)"] for scenario in scenarios]
    execution_times = [results[query].get(scenario, {"Execution Time (ms)": 0.0})["Execution Time (ms)"] for scenario in scenarios]
    
    # Create a new figure for each query
    fig, ax = plt.subplots(figsize=(8, 6))
    
    # Define the bar positions for each query
    bar_positions = range(len(scenarios))
    
    # Plot planning time bars
    ax.bar([pos - bar_width / 2 for pos in bar_positions], planning_times, bar_width, color=planning_color, label="Planning Time")
    
    # Plot execution time bars
    ax.bar([pos + bar_width / 2 for pos in bar_positions], execution_times, bar_width, color=execution_color, label="Execution Time")
    
    # Set x-axis labels (scenarios)
    ax.set_xticks(bar_positions)
    ax.set_xticklabels(scenarios)
    
    # Set labels and title
    ax.set_xlabel("Scenarios")
    ax.set_ylabel("Time (ms)")
    ax.set_title(f"Execution Times for {query}")
    ax.legend(loc="best")
    
    # Save the chart for the current query
    output_chart_path = os.path.join(output_dir, f"{query}_execution_times.png")
    plt.tight_layout()
    plt.savefig(output_chart_path)
    plt.close()

    print(f"Chart for {query} saved at: {output_chart_path}")
