# Script to run outstanding Node.js test cases.
# Takes CSV file as input.
# To be run on the lab PC.

# Trials
TRIALS_PER_TEST_CASE=3
MINUTES_PER_TRIAL=2
MINUTES_PER_TEST_CASE=$((TRIALS_PER_TEST_CASE*MINUTES_PER_TRIAL))

# SLA
MAX_ERROR_RATE_PERCENT=1
MAX_RESPONSE_TIME_IN_MS=10000

# Request details.
REQUEST_PATH="/api/v1/namespaces/nodejs-namespace/services/nodejs-service:8080/proxy/"
APP="nodejs"

# Files.
INPUT_FILE="/home/mv22/Desktop/github/results/nodejs-outstanding-test-cases.csv"
OVERALL_RESULTS_FILE="/home/mv22/Desktop/results/overall-results.csv"
PYTHON_SCRIPT="/home/mv22/Desktop/github/scripts/analyse-jmeter-results-with-shaping-timer.py"

# Calculate duration.
duration_in_seconds=$(($MINUTES_PER_TRIAL*60))

# Calculate total test cases.
TOTAL_TEST_CASES=`wc -l $INPUT_FILE | cut -f 1 -d' '`
test_case_number=0

# Backup previous run.
mv /home/mv22/Desktop/results/*.* /home/mv22/Desktop/results/archive/ 2> /dev/null

# Prepare summary file.
echo "Duration (s),Start,End,Req. per Sec. (low),Req. per Sec. (high),High Duration (s),Low Duration (s),App. Processing Time (ms),Min Pods,Max Pods,Initial Pods,Scale CPU,Max Response Time (ms),Max Error Rate (SLO),Actual Error Rate,Meets SLA?" > $OVERALL_RESULTS_FILE

# Go to JMeter directory
pushd ~/Desktop/apache-jmeter-5.1.1

# Loop through values response time.
# TODO: Read lines into array, as ssh also reads from stdin.
# https://stackoverflow.com/questions/11393817/read-lines-from-a-file-into-a-bash-array/11395181 ...
header_read=0
while IFS=, read -r max_rps_low max_rps_high low_duration high_duration app_response_time min_replicas max_replicas starting_replicas cpu_scale_threshold
do
    echo "Start of loop"
    # Discard header.
    if((header_read==0))
    then
        header_read=1
        continue
    fi

    # Configure the cluster.
    ssh donner "./server-configure-kubernetes.sh $cpu_scale_threshold $min_replicas $max_replicas $starting_replicas $APP"

    # Print information.
    test_case_number=$((test_case_number+1))
    echo "Running test case #$test_case_number/$TOTAL_TEST_CASES: app_response_time=$app_response_time..."

    # Estimate time left.
    awk "BEGIN {printf \"About %.1f minutes to go...\n\", ($TOTAL_TEST_CASES - $test_case_number + 1)*$MINUTES_PER_TEST_CASE}"

    # Run the trials for a single test.
    for((trial_number=1;trial_number<=TRIALS_PER_TEST_CASE;trial_number++))
    do
	    # Pad with zeroes.
	    printf -v trial_string "%02d_%02d" $test_case_number $trial_number

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
	    ssh donner "./server-wait-till-cluster-ready.sh $starting_replicas $APP"
	    echo "Cluster is ready..."

	    # Calculate start time.
	    trial_start_time=`date +"%Y-%m-%d %H:%M:%S"`

	    # Run a single JMeter test.
        JTL_FILE="/home/mv22/Desktop/results/jmeter-$trial_string.jtl"

        ./bin/jmeter -n -t ~/Desktop/github/jmeter/test-plan-with-shaping-timer.jmx \
        -l $JTL_FILE \
        -Jrequest_path=$REQUEST_PATH \
        -Jmax_rps_low=$max_rps_low \
        -Jmax_rps_high=$max_rps_high \
        -Japp_response_time=$app_response_time

        # Create summary report file.
        ./bin/JMeterPluginsCMD.sh --generate-csv $JMETER_REPORT_FILE --input-jtl $JTL_FILE --plugin-type AggregateReport

	    # Calculate end time.
	    trial_end_time=`date +"%Y-%m-%d %H:%M:%S"`

	    # Write statistics.
        max_error_rate=1
	    printf "$duration_in_seconds,$trial_start_time,$trial_end_time,$max_rps_low,$max_rps_high,$high_duration,$low_duration,$app_response_time,$min_replicas,$max_replicas,$starting_replicas,$cpu_scale_threshold,$MAX_RESPONSE_TIME_IN_MS,$max_error_rate," >> $OVERALL_RESULTS_FILE

        # Analyse with Python script.
	    $PYTHON_SCRIPT $JMETER_REPORT_FILE $OVERALL_RESULTS_FILE
    done
done < $INPUT_FILE

# Back up.
BACKUP_FOLDER="/home/mv22/Desktop/results/backup-"`date +"%Y-%m-%d-%H%M"`
mkdir $BACKUP_FOLDER
mv /home/mv22/Desktop/results/*.* $BACKUP_FOLDER
mkdir $BACKUP_FOLDER/scripts
cp $PYTHON_SCRIPT $BACKUP_FOLDER/scripts
cp ~/Desktop/github/jmeter/test-plan-with-shaping-timer.jmx $BACKUP_FOLDER/scripts
cp ~/Desktop/github/scripts/nodejs-outstanding-tests.sh $BACKUP_FOLDER/scripts
cp ~/Desktop/github/scripts/master-* $BACKUP_FOLDER/scripts
cp ~/Desktop/github/scripts/server-* $BACKUP_FOLDER/scripts
cp -r ~/Desktop/github/kubernetes/$APP* $BACKUP_FOLDER/scripts

# Go back to the previous directory.
popd

