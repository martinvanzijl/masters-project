#!/bin/bash

# Check	that the correct number	of pods	are running.
# Parameter 1 is the number of pods which should be running.
# Parameter 2 is the app.

APP=$2
NAMESPACE=$APP-namespace

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

echo "result=$result"
echo "Here comes the output:"
kubectl get pods --namespace=$NAMESPACE

