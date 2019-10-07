#!/usr/bin/gawk -f

# Script for analysing WATERS results.

# From https://stackoverflow.com/questions/9985528/how-can-i-trim-white-space-from-a-variable-in-awk
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

BEGIN {
	header_printed = 0;
}

#match($0, "<(.*)> ... (false|true) \\((.*),(.*),(.*)\\)", matches) {
match($0, "<(.*)> ... (false|true) \\((.*),(.*)\\)", matches) {

	# Get matches.
	i = 1;
	parameters 	= trim(matches[i++]);
	meets		= trim(matches[i++]);
	#states 		= trim(matches[i++]);
	nodes 		= trim(matches[i++]);
	time 		= trim(matches[i++]);

	# Format parameters.
	match(parameters, "(.*)", param_matches);
	split(param_matches[0], param_items, ",");

	# Print header.
	if(!header_printed) {
		for(param_index in param_items) {
			split(param_items[param_index], values, "=");
			printf "%s,", values[1];
		}
		print "meets_sla,verification_time";
		header_printed = 1;
	}

	# Print body.
	for(param_index in param_items) {
		split(param_items[param_index], values, "=");
		printf "%d,", values[2];
	}

	# Format time.
	gsub(" s", "", time);

	# Print final output.
	printf "%s,%s\n", meets, time;
}

