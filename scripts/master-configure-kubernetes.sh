# Configure kubernetes on the master node.

# Get parameters.
scale_cpu_threshold=${1:-50}
min_pods=${2:-2}
max_pods=${3:-4}
starting_pods=${4:-2}
app=${5:-bad-app} # Stop if an invalid app is given.

# First kill the existing pods.
NAMESPACE=$app-namespace
kubectl delete pod --namespace=$NAMESPACE --all

# Apply parameters to Kubernetes.
cat $app.template.yml | sed "s/{{scale_cpu_threshold}}/$scale_cpu_threshold/g;s/{{min_pods}}/$min_pods/g;s/{{max_pods}}/$max_pods/g;s/{{starting_pods}}/$starting_pods/g" | kubectl apply -f - --namespace=$app-namespace

