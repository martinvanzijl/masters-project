# Configure kubernetes on the master node.

# Get parameters.
scale_cpu_threshold=${1:-50}
min_pods=${2:-2}
max_pods=${3:-4}
starting_pods=${4:-2}

# Apply parameters to Kubernetes.
cat nginx.template.yml | sed "s/{{scale_cpu_threshold}}/$scale_cpu_threshold/g;s/{{min_pods}}/$min_pods/g;s/{{max_pods}}/$max_pods/g;s/{{starting_pods}}/$starting_pods/g" | kubectl apply -f - --namespace=nginx-namespace
#cat nginx.template.yml | sed "s/{{scale_cpu_threshold}}/$scale_cpu_threshold/g;s/{{min_pods}}/$min_pods/g;s/{{max_pods}}/$max_pods/g;s/{{starting_pods}}/$starting_pods/g" > file.txt

