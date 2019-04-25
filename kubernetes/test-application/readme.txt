TEST APPLICATION
================

This is a simple test application for Kubernetes.

Create this in Kubernetes running the following command:

  kubectl create deployment hello-node --image=https://github.com/martinvanzijl/masters-project/tree/master/kubernetes/test-application
  
TODO: It seems like I have to make a "Docker Build" of the application first, then refer to that built file in the "create" command. I'll have to try this in Kubernetes itself and see.
