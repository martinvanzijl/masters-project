#!/usr/bin/gawk -f

# Script for asearching for an interesting counter-example.

/------------------------------------------------------------/ {
	in_counter_example = 0;
}

/counterexample:/ {
    in_counter_example = 1;
    print "";
    printf "NEW COUNTER-EXAMPLE: ";
}

/    Submitted:/ {
    requests=$2
    #print "Requests =", requests;
    printf "%d ", requests;
}

END {
    print "";
}

# Perhaps this one: model-2-02Z-nodejs-final<RPS_Max_High=2,RPS_Max_Low=1,T_High=60,T_Low=60,Pods_Initially_On=2,Pod_Min=1,Pod_Max=4,Scale_CPU_Threshold=80,Processing_Time_Per_Req_In_Ms=1000> ... 
false (1896 states, 21196 nodes, 0.417 s)
# This has scaling down in the counter-example...

