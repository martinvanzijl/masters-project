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
s/QL/Pod_Queue_Length/g
s/HPA_SECONDS_ELAPSED/HPA_Seconds_Elapsed/g
s/MAX_REQUESTS_PER_SECOND/Max_Requests_Per_Second/g
s/NEXT_POD_TEMP/Next_Pod_Temp/g
s/NP_TEMP/Next_Pod_Temp/g
s/NP/Next_Pod/g
s/PODS_ON/Pods_On/g
s/POD_SCHEDULER_SECONDS_ELAPSED/Pod_Scheduler_Seconds_Elapsed/g
s/REMAINDER/Submitted_Remainder/g
s/SUBMITTED_THIS_SECOND/Submitted_This_Second/g
s/PI/Pod_Index/g
s/WORKLOAD_SECONDS_ELAPSED/Workload_Seconds_Elapsed/g

