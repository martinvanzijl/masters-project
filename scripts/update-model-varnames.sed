#!/bin/sed -f

s/HPA_CHECK_INTERVAL/HPA_Check_Interval/g
s/MAX_CPU_PER_POD_IN_MILLICPUS/Max_CPU_Per_Pod_In_MilliCPUs/g
s/MAX_RAM_PER_POD_IN_MB/Max_Ram_Per_Pod_In_MB/g
s/MAX_REQUESTS_PER_SECOND_ACTUAL/Max_Requests_Per_Second_Actual/g
s/MAX_RESPONSE_TIME_IN_MS/Max_Response_Time_In_Ms/g
s/PODS_INITIALLY_ON/Pods_Initially_On/g
s/POD_MIN/Pod_Min/g
s/POD_MAX/Pod_Max/g
s/PROCESSING_TIME_PER_REQ_IN_MS/Processing_Time_Per_Req_In_Ms/g
s/REQ_SENT_PER_SEC_HIGH/Req_Sent_Per_Sec_High/g
s/REQ_SENT_PER_SEC_LOW/Req_Sent_Per_Sec_Low/g
s/HIGH_LOAD_TIME_IN_SECONDS/High_Load_Time_In_Seconds/g
s/LOW_LOAD_TIME_IN_SECONDS/Low_Load_Time_In_Seconds/g
s/POD_QUEUE_CAPACITY/Pod_Queue_Capacity/g
s/POD_STARTUP_TIME/Pod_Startup_Time/g
s/REQ_HANDLED_PER_SEC_PER_POD/Req_Handled_Per_Sec_Per_Pod/g
s/SCALE_AMOUNT/Scale_Amount/g
s/SCALE_DOWN_CPU_THRESHOLD/Scale_Down_CPU_Threshold/g
s/SCALE_CPU_THRESHOLD/Scale_CPU_Threshold/g
s/SCALE_DOWN_THRESHOLD_FIRST_POD/Scale_Down_Threshold_First_Pod/g
s/SCALE_THRESHOLD_LAST_POD/Scale_Threshold_Last_Pod/g
s/HPA_SECONDS_ELAPSED/HPA_Seconds_Elapsed/g
s/MAX_REQUESTS_PER_SECOND/Max_Requests_Per_Second/g
s/NEXT_POD_TEMP/Next_Pod_Temp/g
s/PODS_ON/Pods_On/g
s/POD_SCHEDULER_SECONDS_ELAPSED/Pod_Scheduler_Seconds_Elapsed/g
s/REMAINDER/Submitted_Remainder/g
s/SUBMITTED_THIS_SECOND/Submitted_This_Second/g
s/WORKLOAD_SECONDS_ELAPSED/Workload_Seconds_Elapsed/g
s/POD_QUEUE_LENGTH/Pod_Queue_Length/g
s/PODS_CURRENTLY_ON/Pods_Currently_On/g
s/SUM_OF_QUEUE_LENGTHS_BEFORE/Sum_Of_Queue_Lengths_Before/g
s/SUM_OF_QUEUE_LENGTHS_AFTER/Sum_Of_Queue_Lengths_After/g
s/POD_INDEX/Pod_Index/g
s/Pod_Queue_Capacity/Max_Queue_Length/g

# To shorten the the names so that the diagrams fit on the page.
s/Max_Queue_Length/QL_Max/g
s/Pod_Queue_Length/QL/g
s/Submitted_Remainder/Remainder/g
s/Submitted_This_Second/Submitted/g
s/Pods_Currently_On/Pods_On/g
s/Pod_Scheduler_Seconds_Elapsed/PS_Seconds_Elapsed/g
s/Workload_Seconds_Elapsed/W_Seconds_Elapsed/g
s/High_Load_Time_In_Seconds/T_High/g
s/Low_Load_Time_In_Seconds/T_Low/g
s/Max_Requests_Per_Second/RPS_Max/g
s/Req_Sent_Per_Sec_Low/RPS_Max_Low/g
s/Req_Sent_Per_Sec_High/RPS_Max_High/g

# To shorten the the names so that the diagrams fit on the page.
s/Scale_Down_Threshold_First_Pod/Scale_Down_Threshold/g
s/Scale_Threshold_Last_Pod/Scale_Up_Threshold/g

