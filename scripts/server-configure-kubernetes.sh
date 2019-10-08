# Script for configuring kubernetes cluster. To run on the server itself.

# Pass parameters.
cd vagrant-boxes/Kubernetes/
vagrant ssh master -c "./master-configure-kubernetes.sh $1 $2 $3 $4 $5"

