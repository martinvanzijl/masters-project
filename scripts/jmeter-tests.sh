# Script for running the tests for my masters project.
# To be run on the lab PC.

# Trials
TRIALS_PER_TEST_CASE=3
MINUTES_PER_TRIAL=2

# SLA
MAX_ERROR_RATE_PERCENT=1
MAX_RESPONSE_TIME_IN_MS=10000

# Request details.
REQUEST_PATH="/api/v1/namespaces/nginx-namespace/services/nginx:80/proxy/"
#REQUEST_PATH="/api/v1/namespaces/nodejs-namespace/services/nodejs-service:8080/proxy/"
APP="nginx"
#APP="nodejs"

# Files.
OVERALL_RESULTS_FILE="/home/mv22/Desktop/results/overall-results.csv"
PYTHON_SCRIPT="/home/mv22/Desktop/github/scripts/analyse-jmeter-results.py"

# Parameter limits.
CPU_SCALE_THRESHOLD_MIN=80
CPU_SCALE_THRESHOLD_MAX=80
CPU_SCALE_THRESHOLD_INC=25

MAX_RPS_MIN=400
MAX_RPS_MAX=400
MAX_RPS_INC=50

MIN_REPLICAS=1

MAX_REPLICAS_MIN=1
MAX_REPLICAS_MAX=4
MAX_REPLICAS_INC=1

STARTING_REPLICAS=1

USERS_DEFAULT=1000

# Calculate duration.
duration_in_seconds=$(($MINUTES_PER_TRIAL*60))
#duration_in_seconds=10

# Calculate total test cases.
TOTAL_TEST_CASES=$(( ((CPU_SCALE_THRESHOLD_MAX-CPU_SCALE_THRESHOLD_MIN)/CPU_SCALE_THRESHOLD_INC + 1) * ((MAX_RPS_MAX-MAX_RPS_MIN)/MAX_RPS_INC + 1) * ((MAX_REPLICAS_MAX-MAX_REPLICAS_MIN)/MAX_REPLICAS_INC + 1) ))
MINUTES_PER_TEST_CASE=$((TRIALS_PER_TEST_CASE*MINUTES_PER_TRIAL))
test_case_number=0

# Backup previous run.
mv /home/mv22/Desktop/results/*.* /home/mv22/Desktop/results/archive/ 2> /dev/null

# Prepare summary file.
echo "Trial Duration (s),Start,End,Users,Samples per Min.,Samples per Sec.,Min Pods,Max Pods,Initial Pods,Scale CPU Threshold,Max Response Time (ms),Meets SLO,Total Requests,Total Failures,Failure Rate,Max Failure Rate (SLO),Actual Avg. Req. per Sec.,Avg. Burst" > $OVERALL_RESULTS_FILE

# Go to JMeter directory
pushd ~/Desktop/apache-jmeter-5.1.1/bin

# Loop through values for users.
users=$USERS_DEFAULT
#for((users=5;users<=5;users+=1))
#do
    # Loop through values for maximum replicas.
    for((max_replicas=$MAX_REPLICAS_MIN;max_replicas<=$MAX_REPLICAS_MAX;max_replicas+=$MAX_REPLICAS_INC))
    do
	    # Loop through values for CPU scaling threshold.
	    for((cpu_scale_threshold=$CPU_SCALE_THRESHOLD_MIN;cpu_scale_threshold<=$CPU_SCALE_THRESHOLD_MAX;cpu_scale_threshold+=$CPU_SCALE_THRESHOLD_INC))
	    do
		    # Configure the cluster.
		    ssh donner "./server-configure-kubernetes.sh $cpu_scale_threshold $MIN_REPLICAS $max_replicas $STARTING_REPLICAS $APP"

		    # Loop through values for requests per second.
		    for((max_rps=$MAX_RPS_MIN;max_rps<=$MAX_RPS_MAX;max_rps+=$MAX_RPS_INC))
		    do
			    # Print information.
			    test_case_number=$((test_case_number+1))
			    echo "Running test case #$test_case_number/$TOTAL_TEST_CASES: users=$users, cpu=$cpu_scale_threshold, max_replicas=$max_replicas, rps=$max_rps..."

			    # Estimate time left.
			    awk "BEGIN {printf \"About %.1f minutes to go...\n\", ($TOTAL_TEST_CASES - $test_case_number + 1)*$MINUTES_PER_TEST_CASE}"

			    # Calculate maximum requests per minutes.
			    max_rpm=$(($max_rps*60))

			    # Run the trials for a single test.
			    for((trial_number=1;trial_number<=TRIALS_PER_TEST_CASE;trial_number++))
			    do
				    # Pad with zeroes.
				    printf -v trial_string "%02d_%02d_%03d_%03d_%02d" $users $max_replicas $cpu_scale_threshold $max_rps $trial_number

				    # Calculate results file.
				    JMETER_OUT_FILE="/home/mv22/Desktop/results/jmeter-$trial_string.txt"
                    JMETER_REPORT_FILE="/home/mv22/Desktop/results/report-$trial_string.csv"
				    RESULTS_FILE="/home/mv22/Desktop/results/results-$trial_string.csv"

                    # Print message.
				    echo "Running trial number #$trial_number/$TRIALS_PER_TEST_CASE..."

				    # Wait for cluster to be ready.
                    echo "Killing existing pods..."
                    ssh donner "./server-kill-pods.sh $APP"
                    echo "Pods killed..."
				    echo "Waiting for cluster to be ready..."
				    ssh donner "./server-wait-till-cluster-ready.sh $STARTING_REPLICAS $APP"
				    echo "Cluster is ready..."

				    # Calculate start time.
				    trial_start_time=`date +"%Y-%m-%d %H:%M:%S"`

				    # Run a single JMeter test.
				    # -l ~/Desktop/results/results-$trial_string.txt
				    jmeter -n -t ~/Desktop/github/jmeter/test-plan.jmx \
                        -Joutput_csv_file="$RESULTS_FILE" \
                        -Joutput_report_file="$JMETER_REPORT_FILE" \
                        -Jduration_in_seconds=$duration_in_seconds \
                        -Jmax_rpm=$max_rpm \
                        -Jrequest_path=$REQUEST_PATH \
                        -Jusers=$users ###\
                        ###> $JMETER_OUT_FILE

				    # Calculate end time.
				    trial_end_time=`date +"%Y-%m-%d %H:%M:%S"`

				    # Write statistics header.
				    printf "$duration_in_seconds,$trial_start_time,$trial_end_time,$users,$max_rpm,$max_rps,$MIN_REPLICAS,$max_replicas,$STARTING_REPLICAS,$cpu_scale_threshold,$MAX_RESPONSE_TIME_IN_MS," >> $OVERALL_RESULTS_FILE

                    # Analyse with Python script.
				    $PYTHON_SCRIPT $RESULTS_FILE $RESULTS_FILE.out $trial_string $MAX_ERROR_RATE_PERCENT $OVERALL_RESULTS_FILE
			    done
		    done
	    done
    done
#done

# Back up.
BACKUP_FOLDER="/home/mv22/Desktop/results/backup-"`date +"%Y-%m-%d-%H%M"`
mkdir $BACKUP_FOLDER
mv /home/mv22/Desktop/results/*.* $BACKUP_FOLDER

# Go back to the previous directory.
popd

