#!/usr/bin/python

# Import modules.
import csv
import sys
from datetime import datetime

# Function to read argument.
def read_arg(number, default):
    if len(sys.argv) > number:
        return sys.argv[number]
    else:
        return default

# Read arguments.
report_file_name     = read_arg(1, "/home/mv22/Desktop/results/report.csv")
summary_file_name    = read_arg(2, "/home/mv22/Desktop/results/summary.csv")
max_error_rate       = float(read_arg(3, 1))

# Open the file.
with open(report_file_name) as report_file:
    csv_reader = csv.reader(report_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            # Header row.
            line_count = line_count + 1
        else:
            # Body row.
            [label, samples, average, median, percentile_90, percentile_95, percentile_99, min_time, max_time, error_percent, throughput, received, std_dev] = row
            print "Error percent =", error_percent
            error_as_float = float(error_percent.replace("%",""))
            meets_sla = error_as_float <= max_error_rate

# Add them to the file.
summary_file = open(summary_file_name, "a")
csv_writer = csv.writer(summary_file)
csv_writer.writerow([error_percent, meets_sla])
summary_file.close()

