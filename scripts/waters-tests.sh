# Run WATERS tests for my thesis.

# Constants.
#MODEL="../models/model-2-01-nginx.wmod"
MODEL="../models/model-2-02-nodejs.wmod"
OUTPUT_FILE="../results/waters-results.txt"

# Change to "wcheck" directory.
pushd ../waters

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
    #./wcheck -bdd -lang -q -DMAX_REQUESTS_PER_SECOND=$max_rps ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

#for ((pods_initial = 1; pods_initial <= 4; pods_initial += 1))
#do
    #echo "Testing pods_initial $pods_initial"
    #echo "Test with PODS_INITIALLY_ON = $pods_initial" >> $OUTPUT_FILE
    #./wcheck -bdd -lang -q -DPODS_INITIALLY_ON=$pods_initial ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

#for ((pod_max = 3; pod_max <= 6; pod_max += 1))
#do
    #echo "Testing pod_max $pod_max"
    #echo "Test with POD_MAX = $pod_max" >> $OUTPUT_FILE
    #./wcheck -bdd -lang -q -DPOD_MAX=$pod_max ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

#for ((scale_cpu = 10; scale_cpu <= 100; scale_cpu += 10))
#do
    #echo "Testing scale_cpu $scale_cpu"
    #echo "Test with SCALE_CPU_THRESHOLD = $scale_cpu" >> $OUTPUT_FILE
    #./wcheck -bdd -lang -q -DSCALE_CPU_THRESHOLD=$scale_cpu ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
#done

#for ((max_rps = 200; max_rps <= 400; max_rps += 100))
#do
	#for ((pods_initial = 1; pods_initial <= 4; pods_initial += 1))
	#do
		#echo "Testing max_rps $max_rps pods_initial $pods_initial"
		#echo "Test with MAX_REQUESTS_PER_SECOND $max_rps PODS_INITIALLY_ON = $pods_initial" >> $OUTPUT_FILE
		#./wcheck -bdd -lang -q -DMAX_REQUESTS_PER_SECOND=$max_rps -DPODS_INITIALLY_ON=$pods_initial ../models/model-2-01-nginx.wmod >> $OUTPUT_FILE
	#done
#done

#for ((pod_max = 1; pod_max <= 4; pod_max += 1))
for ((scale_cpu = 50; scale_cpu <= 100; scale_cpu += 50))
do
	#for ((scale_cpu = 50; scale_cpu <= 100; scale_cpu += 50))
    for ((pod_max = 1; pod_max <= 4; pod_max += 1))
	do
		for ((max_rps = 1; max_rps <= 2; max_rps += 1))
		do
			echo "Testing max_rps=$max_rps, pod_max=$pod_max, scale_cpu=$scale_cpu..."
			./wcheck -bdd -lang -q -DMAX_REQUESTS_PER_SECOND=$max_rps -DPOD_MAX=$pod_max -DSCALE_CPU_THRESHOLD=$scale_cpu $MODEL >> $OUTPUT_FILE
		done
	done
done

# Go back to the previous directory.
popd

# Analyse the results
./analyse-waters-results.awk $OUTPUT_FILE > ../results/waters-analysis.csv
echo "Results are in ../results/waters-analysis.csv"

