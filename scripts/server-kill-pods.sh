# Script for killing pods. To run on the server itself.

# Pass parameters.
cd vagrant-boxes/Kubernetes/
vagrant ssh master -c "./master-kill-pods.sh $1"

