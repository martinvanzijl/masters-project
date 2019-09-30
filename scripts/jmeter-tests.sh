# Script for running the tests for my masters project.
# To be run on the lab PC.

# Trials
TRIALS_PER_TEST_CASE=2
MINUTES_PER_TRIAL=1

# SLA
MAX_ERROR_RATE_PERCENT=1

# Cluster
MIN_REPLICAS=2
MAX_REPLICAS=4
STARTING_REPLICAS=2
CPU_SCALE_THRESHOLD_DEFAULT=50

# Files.
OVERALL_RESULTS_FILE="/home/mv22/Desktop/results/overall-results.csv"
PYTHON_SCRIPT="/home/mv22/Desktop/github/scripts/analyse-jmeter-results.py"

# Waiting times.
WAITING_TIME_AFTER_CONFIGURING_CLUSTER=1
WAITING_TIME_BETWEEN_TRIALS_IN_SECONDS=1

# Parameter limits.
CPU_SCALE_THRESHOLD_MIN=20
CPU_SCALE_THRESHOLD_MAX=100
CPU_SCALE_THRESHOLD_INC=20

MAX_RPS_MIN=200
MAX_RPS_MAX=1000
MAX_RPS_INC=200

# Calculate duration.
#duration_in_seconds=$(($MINUTES_PER_TRIAL*60))
duration_in_seconds=5

# Prepare summary file.
echo "Trial Duration (s),Samples per Minute (max_rpm),Samples per Second,Min Pods (minReplicas),Max Pods (maxReplicas),Initial Pods (replicas),Scale CPU Threshold (averageUtilization),Meets SLO,Total Requests,Total Failures,Failure Rate,Max Failure Rate (SLO)" > $OVERALL_RESULTS_FILE

# Go to JMeter directory
pushd ~/Desktop/apache-jmeter-5.1.1/bin

# Loop through values for CPU scaling threshold.
for((cpu_scale_threshold=$CPU_SCALE_THRESHOLD_MIN;cpu_scale_threshold<=$CPU_SCALE_THRESHOLD_MAX;cpu_scale_threshold+=$CPU_SCALE_THRESHOLD_INC))
do
	# Configure the cluster.
	#echo "Configuring cluster $cpu_scale_threshold $MIN_REPLICAS $MAX_REPLICAS $STARTING_REPLICAS..."
	ssh donner "./server-configure-kubernetes.sh $cpu_scale_threshold $MIN_REPLICAS $MAX_REPLICAS $STARTING_REPLICAS"
	#echo "Waiting for cluster to organize itself..."
	sleep $WAITING_TIME_AFTER_CONFIGURING_CLUSTER

	# Loop through values for requests per second.
	for((max_rps=$MAX_RPS_MIN;max_rps<=$MAX_RPS_MAX;max_rps+=$MAX_RPS_INC))
	do
		echo "Running test case with cpu_scale_threshold=$cpu_scale_threshold and max_rps=$max_rps..."

		# Calculate maximum requests per minutes.
		max_rpm=$(($max_rps*60))

		# Run the trials for a single test.
		for((trial_number=1;trial_number<=TRIALS_PER_TEST_CASE;trial_number++))
		do
			# Pad with zeroes.
			printf -v trial_string "%03d_%03d_%02d" $cpu_scale_threshold $max_rps $trial_number

			# Calculate results file.
			JMETER_OUT_FILE="/home/mv22/Desktop/results/jmeter-$trial_string.csv"
			RESULTS_FILE="/home/mv22/Desktop/results/results-$trial_string.csv"

			echo "Running trial number #$trial_number"

			# Run a single JMeter test.
			# -l ~/Desktop/results/results-$trial_string.txt
			jmeter -n -t ~/Desktop/github/jmeter/test-plan-nginx.jmx -Joutput_csv_file="$RESULTS_FILE" -Joutput_report_file="/home/mv22/Desktop/results/report-$trial_string.xml" -Jduration_in_seconds=$duration_in_seconds -Jmax_rpm=$max_rpm > $JMETER_OUT_FILE

			# Write statistics
			printf "$duration_in_seconds,$max_rpm,$max_rps,$MIN_REPLICAS,$MAX_REPLICAS,$STARTING_REPLICAS,$cpu_scale_threshold," >> $OVERALL_RESULTS_FILE
			$PYTHON_SCRIPT $RESULTS_FILE $RESULTS_FILE.out $trial_string $MAX_ERROR_RATE_PERCENT $OVERALL_RESULTS_FILE

			# Wait for the cluster to recover
			sleep $WAITING_TIME_BETWEEN_TRIALS_IN_SECONDS

			# Estimate time left.
			awk "BEGIN {printf \"About %.1f minutes to go...\", ($CPU_SCALE_THRESHOLD_MAX - $cpu_scale_threshold) / $CPU_SCALE_THRESHOLD_MAX * $TRIALS_PER_TEST_CASE * $duration_in_seconds/60}"
		done
	done
done

# Go back to the previous directory.
popd

