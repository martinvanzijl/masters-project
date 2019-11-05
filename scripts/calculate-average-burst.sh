# Script for running the tests for my masters project.
# To be run on the lab PC.

SUMMARY_FILE=~/Desktop/results/summary.csv

# Write header.
echo "Meets SLA?", "Total Requests", "Total Failures", "Error Rate", "Max Error Rate", "Average RPS", "Average Burst" > $SUMMARY_FILE

# Write body.
for jtl_file in ~/Desktop/results/stored/backup-2019-10-31-0851/*.jtl
do
    ./calculate-average-burst.py $jtl_file
done

