# Script for running the tests for my masters project.
# To be run on the lab PC.

# Constants
NUMBER_OF_TRIALS=2
MAX_ERROR_RATE_PERCENT=1
MIN_REPLICAS=2
MAX_REPLICAS=4
STARTING_REPLICAS=2
CPU_SCALE_THRESHOLD=50
MINUTES_PER_TRIAL=1
OVERALL_RESULTS_FILE="/home/mv22/Desktop/results/overall-results.csv"
PYTHON_SCRIPT="/home/mv22/Desktop/github/scripts/analyse-jmeter-results.py"
WAITING_TIME_BETWEEN_TRIALS_IN_SECONDS=1

# Calculate duration.
duration_in_seconds=$(($MINUTES_PER_TRIAL*60))

# Prepare summary file.
echo "Trial Duration (s),Samples per Minute (max_rpm),Samples per Second,Min Pods (minReplicas),Max Pods (maxReplicas),Initial Pods (replicas),Scale CPU Threshold (averageUtilization),Meets SLO,Total Requests,Total Failures,Failure Rate,Max Failure Rate (SLO)" > $OVERALL_RESULTS_FILE

# Go to JMeter directory
pushd ~/Desktop/apache-jmeter-5.1.1/bin

# Loop through values for requests per second.
for((max_rps=200;max_rps<=400;max_rps+=200))
do
	# Calculate maximum requests per minutes.
	max_rpm=$(($max_rps*60))

	# Run the trials for a single test.
	for((trial_number=1;trial_number<=NUMBER_OF_TRIALS;trial_number++))
	do
		# Pad with zeroes.
		printf -v trial_string "%03d_%02d" $max_rps $trial_number

		# Calculate results file.
		RESULTS_FILE="/home/mv22/Desktop/results/results-$trial_string.csv"

		# Run a single JMeter test.
		# -l ~/Desktop/results/results-$trial_string.txt
		jmeter -n -t ~/Desktop/github/jmeter/test-plan-nginx.jmx -Joutput_csv_file="$RESULTS_FILE" -Joutput_report_file="/home/mv22/Desktop/results/report-$trial_string.xml" -Jduration_in_seconds=$duration_in_seconds -Jmax_rpm=$max_rpm

		# Write statistics
		printf "$duration_in_seconds,$max_rpm,$max_rps,$MIN_REPLICAS,$MAX_REPLICAS,$STARTING_REPLICAS,$CPU_SCALE_THRESHOLD," >> $OVERALL_RESULTS_FILE
		$PYTHON_SCRIPT $RESULTS_FILE $RESULTS_FILE.out $trial_string $MAX_ERROR_RATE_PERCENT $OVERALL_RESULTS_FILE

		# Wait for the cluster to recover
		sleep $WAITING_TIME_BETWEEN_TRIALS_IN_SECONDS
	done
done

# Go back to the previous directory.
popd

