# Script to wait for cluster to be ready. To run on the server itself.

# Pass parameters.
cd vagrant-boxes/Kubernetes/
vagrant ssh master -c "./master-wait-till-cluster-ready.sh $1"

