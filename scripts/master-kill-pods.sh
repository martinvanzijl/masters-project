# Kill existing pods.

app=${1:-bad-app} # Stop if an invalid app is given.

NAMESPACE=$app-namespace
kubectl delete pod --namespace=$NAMESPACE --all

