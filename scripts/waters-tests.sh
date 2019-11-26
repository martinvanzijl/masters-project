# Run WATERS tests for my thesis.

# Constants.
MODEL=~/Desktop/github/models/model-2-02Z-nodejs-final.wmod
OUTPUT_FILE=~/Desktop/github/results/waters-results.txt

# Change to "wcheck" directory.
if [ -d ~/Desktop/waters ]
then
    pushd ~/Desktop/waters
else
    pushd ~/Desktop/github/waters
fi

# Back up output file.
if [ -f $OUTPUT_FILE ]
then
    mv $OUTPUT_FILE $OUTPUT_FILE".backup"
fi

# Run tests.
#for ((scale_cpu = 50; scale_cpu <= 100; scale_cpu += 50))
#do
#    for ((pod_max = 1; pod_max <= 4; pod_max += 1))
#	do
#		for ((max_rps = 1; max_rps <= 2; max_rps += 1))
#		do
#			echo "Testing max_rps=$max_rps, pod_max=$pod_max, scale_cpu=$scale_cpu..."
#			./wcheck -bdd -lang -q -DMAX_REQUESTS_PER_SECOND=$max_rps -DPOD_MAX=$pod_max -DSCALE_CPU_THRESHOLD=$scale_cpu $MODEL >> $OUTPUT_FILE
#		done
#	done
#done

# Test from CSV file.
INPUT_FILE=~/Desktop/github/results/test-cases.csv
#INPUT_FILE=~/Desktop/github/results/speed-test-cases.csv
HEADER_READ=0

while IFS=, read -r rps_low rps_high high_duration low_duration app_processing_time min_pods max_pods initial_pods scale_cpu
#while IFS=, read -r rps min_pods max_pods initial_pods scale_cpu
do
    if ((HEADER_READ==0))
    then
        HEADER_READ=1
    else
        echo "Testing: $rps_low|$rps_high|$high_duration|$low_duration|$app_processing_time|$min_pods|$max_pods|$initial_pods|$scale_cpu"
        #echo "Testing: $rps|$min_pods|$max_pods|$initial_pods|$scale_cpu"
        #app_processing_time=6 # hard code response time

        # NGINX
        #./wcheck -bdd -lang -q -stats \
                                        #-DMAX_REQUESTS_PER_SECOND_ACTUAL=$rps \
                                        #-DPOD_MIN=$min_pods \
                                        #-DPOD_MAX=$max_pods \
                                        #-DPROCESSING_TIME_PER_REQ_IN_MS=$app_processing_time \
                                        #-DSCALE_CPU_THRESHOLD=$scale_cpu \
                                        #$MODEL \
                                        #>> $OUTPUT_FILE

        # Node.js
        ./wcheck -bdd -lang -q -stats \
                                        -DREQ_SENT_PER_SEC_HIGH=$rps_high \
                                        -DREQ_SENT_PER_SEC_LOW=$rps_low \
                                        -DHIGH_LOAD_TIME_IN_SECONDS=$high_duration \
                                        -DLOW_LOAD_TIME_IN_SECONDS=$low_duration \
                                        -DPODS_INITIALLY_ON=$initial_pods \
                                        -DPOD_MIN=$min_pods \
                                        -DPOD_MAX=$max_pods \
                                        -DSCALE_CPU_THRESHOLD=$scale_cpu \
                                        -DPROCESSING_TIME_PER_REQ_IN_MS=$app_processing_time \
                                        $MODEL \
                                        >> $OUTPUT_FILE

        # I could use this to get the total time (verification + compilation):
        # /usr/bin/time ... --append --format='TOTAL_TIME:%E' --output=$OUTPUT_FILE
    fi
done < $INPUT_FILE

# Go back to the previous directory.
popd

# Analyse the results
ANALYSIS_FILE=~/Desktop/github/results/waters-analysis.csv
./analyse-waters-results.awk $OUTPUT_FILE > $ANALYSIS_FILE
echo "Results are in $ANALYSIS_FILE"

