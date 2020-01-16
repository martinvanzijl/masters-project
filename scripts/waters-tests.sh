# Run WATERS tests for my thesis.

# Constants.
#MODEL=~/Desktop/github/models/model-2-01Z-nginx-final.wmod
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

# Test from CSV file.
INPUT_FILE=~/Desktop/github/results/test-cases.csv
#INPUT_FILE=~/Desktop/github/results/speed-test-cases.csv
HEADER_READ=0

#NGINX
#while IFS=, read -r rps min_pods max_pods initial_pods scale_cpu
# Node.js
while IFS=, read -r rps_low rps_high high_duration low_duration app_processing_time min_pods max_pods initial_pods scale_cpu
do
    if ((HEADER_READ==0))
    then
        HEADER_READ=1
    else
        # NGINX
        #echo "Testing: $rps|$min_pods|$max_pods|$initial_pods|$scale_cpu"
        # Node.js
        echo "Testing: $rps_low|$rps_high|$high_duration|$low_duration|$app_processing_time|$min_pods|$max_pods|$initial_pods|$scale_cpu"

        # NGINX
        #app_processing_time=6 # hard code processing time parameter
        #ql_max_limit=1 # test limiting parameter

        # NGINX
        #./wcheck -bdd -lang -q -stats \
                                        #-DRPS_Max_Actual=$rps \
                                        #-DPod_Min=$min_pods \
                                        #-DPod_Max=$max_pods \
                                        #-DProcessing_Time_Per_Req_In_Ms=$app_processing_time \
                                        #-DScale_CPU_Threshold=$scale_cpu \
                                        #$MODEL \
                                        #>> $OUTPUT_FILE

                                        #-DQL_Max_Limit=$ql_max_limit \
        # Node.js
        ./wcheck -bdd -lang -q -stats \
                                        -DRPS_Max_High=$rps_high \
                                        -DRPS_Max_Low=$rps_low \
                                        -DT_High=$high_duration \
                                        -DT_Low=$low_duration \
                                        -DPods_Initially_On=$initial_pods \
                                        -DPod_Min=$min_pods \
                                        -DPod_Max=$max_pods \
                                        -DScale_CPU_Threshold=$scale_cpu \
                                        -DProcessing_Time_Per_Req_In_Ms=$app_processing_time \
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

# Back up.
BACKUP_FOLDER=~/Desktop/github/results/waters/backup-`date +"%Y-%m-%d-%H%M"`
mkdir $BACKUP_FOLDER
cp $MODEL $BACKUP_FOLDER
cp $OUTPUT_FILE $BACKUP_FOLDER
cp $INPUT_FILE $BACKUP_FOLDER
cp $ANALYSIS_FILE $BACKUP_FOLDER
cp $0 $BACKUP_FOLDER

