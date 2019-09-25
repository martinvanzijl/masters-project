# Run WATERS tests for my thesis.

# Constants.
OUTPUT_FILE="../results/waters-results.txt"

# Change to "wcheck" directory.
pushd ~/Desktop/Meesters/waters

# Back up output file.
if [ -f $OUTPUT_FILE ]
then
    mv $OUTPUT_FILE $OUTPUT_FILE".backup"
fi

# Run tests.
#for ((max_rps = 100; max_rps <= 1000; max_rps += 100))
#do
    #echo "Testing max rps $max_rps"
    #echo "Test with MAX_REQUESTS_PER_SECOND = $max_rps" >> $OUTPUT_FILE
    #./wcheck -native -lang -q -DMAX_REQUESTS_PER_SECOND=$max_rps ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

#for ((pods_initial = 1; pods_initial <= 4; pods_initial += 1))
#do
    #echo "Testing pods_initial $pods_initial"
    #echo "Test with PODS_INITIALLY_ON = $pods_initial" >> $OUTPUT_FILE
    #./wcheck -native -lang -q -DPODS_INITIALLY_ON=$pods_initial ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

#for ((pod_max = 3; pod_max <= 6; pod_max += 1))
#do
    #echo "Testing pod_max $pod_max"
    #echo "Test with POD_MAX = $pod_max" >> $OUTPUT_FILE
    #./wcheck -native -lang -q -DPOD_MAX=$pod_max ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

for ((scale_cpu = 10; scale_cpu <= 100; scale_cpu += 10))
do
    echo "Testing scale_cpu $scale_cpu"
    echo "Test with SCALE_CPU_THRESHOLD = $scale_cpu" >> $OUTPUT_FILE
    ./wcheck -native -lang -q -SCALE_CPU_THRESHOLD=$scale_cpu ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
done

# Go back to the previous directory.
popd
