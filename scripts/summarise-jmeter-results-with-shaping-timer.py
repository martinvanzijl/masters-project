#!/usr/bin/python

# Import modules.
import csv
import sys

# Function to read argument.
def read_arg(number, default):
    if len(sys.argv) > number:
        return sys.argv[number]
    else:
        return default

# Read arguments.
input_file_name     = read_arg(1, "/home/mv22/Desktop/results/overall-results.csv")
output_file_name    = read_arg(2, "/home/mv22/Desktop/results/summary.csv")

# Create dictionary
summary = {}

# Read the input file.
with open(input_file_name) as input_file:
    csv_reader = csv.reader(input_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            # Header row.
            line_count = line_count + 1
        else:
            # Body row.
            [duration, start, end, rps_low, rps_high, high_duration, low_duration, app_processing_time, pods_min, pods_max, initial_pods, scale_cpu_threshold, max_response_time, max_error_rate, actual_error_rate, meets_slo] = row
            key = ",".join([rps_low, rps_high, high_duration, low_duration, app_processing_time, pods_min, pods_max, initial_pods, scale_cpu_threshold])
            value = int(meets_slo == "True")
            if not key in summary:
                summary[key] = []
            summary[key].append(value)
            line_count = line_count + 1

# Write the output file.
output_file = open(output_file_name, "w")
csv_writer = csv.writer(output_file)

csv_writer.writerow(["RPS (low)", "RPS (high)", "Duration (low)", "Duration (high)", "App. Processing Time", "Min Pods", "Max Pods", "Initial Pods", "Scale CPU", "Value 1", "Value 2", "Value 3", "Average", "Meets"])
for key in sorted(summary):
    values = summary[key]
    average = float(sum(values)) / float(len(values))
    meets = average >= 0.5
    row = key.split(",")
    row.extend(values)
    row.append(average)
    row.append(meets)
    csv_writer.writerow(row)

output_file.close()

