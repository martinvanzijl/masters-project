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
            [duration, start, end, users, req_per_min, req_per_sec, min_pods, max_pods, initial_pods, scale_cpu_threshold, max_response_time, meets_slo, total_requests, total_failures, failure_rate, max_failure_rate, actual_average_rps, average_burst] = row
            key = ",".join([users, req_per_sec, min_pods, max_pods, initial_pods, scale_cpu_threshold])
            value = int(meets_slo)
            if not key in summary:
                summary[key] = []
            summary[key].append(value)
            line_count = line_count + 1

# Write the output file.
output_file = open(output_file_name, "w")
csv_writer = csv.writer(output_file)

#csv_writer.writerow(["Users", "RPS", "Min Pods", "Max Pods", "Initial Pods", "Scale CPU", "Value 1", "Value 2", "Value 3", "Average", "Meets"])
csv_writer.writerow(["Users", "RPS", "Min Pods", "Max Pods", "Initial Pods", "Scale CPU", "Value 1", "Value 2", "Value 3", "Proportion", "Meets"])
for key in sorted(summary):
    values = summary[key]
    trials_meeting_sla = sum(values)
    total_trials = len(values)
    average = float(trials_meeting_sla) / float(total_trials)
    meets = average >= 0.5
    proportion = str(trials_meeting_sla) + "/" + str(total_trials)
    row = key.split(",")
    row.extend(values)
    #row.append(average)
    row.append(proportion)
    row.append(meets)
    csv_writer.writerow(row)

output_file.close()

