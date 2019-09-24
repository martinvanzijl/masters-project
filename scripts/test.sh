# Script for running the tests for my masters project.
# To be run on the lab PC.

# Constants
NUMBER_OF_TRIALS=20

# Go to JMeter directory
pushd ~/Desktop/apache-jmeter-5.1.1/bin

# Run the trials.
for((trial_number=0;trial_number<NUMBER_OF_TRIALS;trial_number++))
do
	# Run a single JMeter test.
	jmeter -n -t ~/Desktop/github/jmeter/test-plan-nginx.jmx -l ~/Desktop/results/results-$trial_number.txt

	# Wait for the cluster to recover
	#sleep 30
	sleep 1
done

# Go back to the previous directory.
popd

