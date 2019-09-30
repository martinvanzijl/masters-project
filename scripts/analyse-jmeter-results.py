#!/usr/bin/python

# Analyze the results from JMeter.
# Reports:
# 1) How many samples were sent each second, so that I can
# put this in the WATERS model.
# 2) Whether the SLO was met. 

# Import modules.
import csv
import sys
from datetime import datetime

# Sample rate dictionary.
# (date-time => [number of requests sent, number of errors]).
samples = {}
REQUESTS_SENT_INDEX = 0
ERRORS_INDEX = 1

# Column definitions.
COLUMN_SUCCESS = 4

# Globals.
total_requests = 0
total_failures = 0

# Function to read argument.
def read_arg(number, default):
    if len(sys.argv) > number:
        return sys.argv[number]
    else:
        return default

# Read arguments.
input_file_name     = read_arg(1, "/home/mv22/Desktop/results/table.csv")
output_file_name    = read_arg(2, "/home/mv22/Desktop/results/output.csv")
trial_number        = read_arg(3, "1")
max_error_rate_slo  = int(read_arg(4, "0"))
summary_file_name  	= read_arg(5, "/home/mv22/Desktop/results/summary.csv")

# Open the file.
with open(input_file_name) as csv_file:
	csv_reader = csv.reader(csv_file, delimiter=',')
	line_count = 0
	for row in csv_reader:
		if line_count == 0:
			# Header row.
			#print('Column names are', row)
			line_count = line_count + 1
		else:
			# Body row.
			# Get timestamp (first field).
			total_requests += 1
			timestamp_string = row[0]
			timestamp_number = int(timestamp_string)
			# Convert from ms to seconds
			# https://stackoverflow.com/questions/31548132/python-datetime-fromtimestamp-yielding-valueerror-year-out-of-range
			timestamp_number /= 1000
			# Convert to date-time.
			dt_object = datetime.fromtimestamp(timestamp_number)
			# Add to dictionary.
			try:
				samples[dt_object][REQUESTS_SENT_INDEX] += 1
			except:
				samples[dt_object] = [1, 0]
			# Count errors.
			success = row[COLUMN_SUCCESS]
			if success == "false":
				samples[dt_object][ERRORS_INDEX] += 1
				total_failures += 1

# Open output file.
output_file = open(output_file_name, "w")
csv_writer = csv.writer(output_file)

# Write results.
csv_writer.writerow(["Second", "Requests", "Errors"])

for key in sorted(samples):
	second = key.strftime("%H:%M:%S")
	requests_sent = samples[key][REQUESTS_SENT_INDEX]
	errors = samples[key][ERRORS_INDEX]
	csv_writer.writerow([second, requests_sent, errors])

# Close output file.
output_file.close()

# Calculate statistics and SLA compliance.
if total_requests == 0:
    error_rate = "N/A"
    meets_sla = "N/A"
else:
    error_rate = float(total_failures) / float(total_requests) * 100
    meets_sla = error_rate <= max_error_rate_slo

total_seconds = len(samples)
if total_seconds == 0:
	average_requests_per_second = "N/A"
else:
	average_requests_per_second = total_requests / total_seconds

# Write overall statistics.
#print "Trial #:", trial_number
#print "Total requests:", total_requests
#print "Total failures:", total_failures
#print "Error rate:", int(error_rate), "%"
#print "Meets SLA?:", meets_sla
#print "Average requests per second:", average_requests_per_second

# Add them to the file.
summary_file = open(summary_file_name, "a")
summary_file.write(str(meets_sla) + "," + str(total_requests) + "," + str(total_failures) + "," + str(int(error_rate)) + "%" + "," + str(max_error_rate_slo) + "\n")
summary_file.close()

