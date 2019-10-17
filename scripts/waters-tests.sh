# Run WATERS tests for my thesis.

# Constants.
MODEL=~/Desktop/github/models/model-2-01-nginx.wmod
#MODEL="../models/model-2-02-nodejs.wmod"
OUTPUT_FILE=~/Desktop/github/results/waters-results.txt

# Change to "wcheck" directory.
pushd ~/Desktop/waters

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
HEADER_READ=0

processing_time=6

while IFS=, read -r max_rps pod_min pod_max initial_pods scale_cpu
do
    if ((HEADER_READ==0))
    then
        HEADER_READ=1
    else
        echo "Testing: $max_rps|$pod_min|$pod_max|$initial_pods|$scale_cpu"
        ./wcheck -bdd -lang -q  -DREQ_SENT_PER_SEC_HIGH=$max_rps \
                                -DREQ_SENT_PER_SEC_LOW=$max_rps \
                                -DPOD_MIN=$pod_min \
                                -DPOD_MAX=$pod_max \
                                -DPROCESSING_TIME_PER_REQ_IN_MS=$processing_time \
                                -DSCALE_CPU_THRESHOLD=$scale_cpu \
                                $MODEL \
                                 >> $OUTPUT_FILE
    fi
done < $INPUT_FILE

# Go back to the previous directory.
popd

# Analyse the results
ANALYSIS_FILE=~/Desktop/github/results/waters-analysis.csv
./analyse-waters-results.awk $OUTPUT_FILE > $ANALYSIS_FILE
echo "Results are in $ANALYSIS_FILE"

