#!/bin/bash

# Check	that the correct number	of pods	are running.
# Parameter 1 is the number of pods which should be running.
# Parameter 2 is the app.

APP=$2
NAMESPACE=$APP-namespace

# There is a flaw here. Pods in "ContainerCreating" status may mean the actual
# number of pods running at the start of the trial may be greater than the
# the "starting pods" parameter in the YAML configuration file.
# (Discovered on 24 Jan 2020.)

# This is important since the starting number of pods has great influence on
# SLA compliance.

# From a research point of view, this means that the "Initial Pods" parameter
# in my results does not truly reflect the starting number of pods in the trial.
# This is really a dependent variable that based partly on the "leftover" metrics
# from the previous trial (remember that the Kubernetes HPA discards metrics from
# pods under a certain age).

# This could be fixed by checking that "runnings==pods" instead of "running>=pods"
# and also checking that container_creating==0. This may add a substantial delay
# between the running of trials, however. This could also possibly be fixed by adding a
# fixed delay (about 5 minutes) after re-configuring the cluster, before
# commencing the JMeter load test.

# Wait for the cluster to set up again.
result=`kubectl get pods --namespace=$NAMESPACE | awk -v pods=$1 '
        /Pending/{pending++}
        /Running/{running++}
        /Succeeded/{succeeded++}
        /Failed/{failed++}
        /Unknown/{unknown++}

        END{
            	if(running>=pods && succeeded==0 && failed==0 && unknown==0){
                        print 1
                } else {
                        print 0
                }
        }
'`

while [ $result -eq 0 ]
do
	#echo "." >&2
	sleep 5
	result=`kubectl get pods --namespace=$NAMESPACE | awk -v pods=$1 '
		    /Pending/{pending++}
		    /Running/{running++}
		    /Succeeded/{succeeded++}
		    /Failed/{failed++}
		    /Unknown/{unknown++}

		    END{
		        	if(running>=pods && succeeded==0 && failed==0 && unknown==0){
		                    print 1
		            } else {
		                    print 0
		            }
		    }
	'`
done

kubectl get pods --namespace=$NAMESPACE

