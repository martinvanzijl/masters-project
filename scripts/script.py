#!/usr/bin/python

# Analyze the results from JMeter.
# At the moment this just checks how many samples were sent each second, so that I can
# put this in my WATERS model.

# Import modules.
import csv
from datetime import datetime

# Sample rate dictionary.
# (date-time => [number of requests sent, number of errors]).
samples = {}
REQUESTS_SENT_INDEX = 0
ERRORS_INDEX = 1

# Column definitions.
COLUMN_SUCCESS = 4

# Open the file.
with open('../results/results-table.csv') as csv_file:
	csv_reader = csv.reader(csv_file, delimiter=',')
	line_count = 0
	for row in csv_reader:
		if line_count == 0:
			# Header row.
			#print('Column names are', row)
			line_count = line_count + 1
		else:
			# Get timestamp (first field).
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

# Open output file.
output_file = open("output.csv", "w")
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

