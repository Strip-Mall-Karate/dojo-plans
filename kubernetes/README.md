# Kubernetes

NOTE: This plan requires at least 8 GB of RAM to compile (according to [this issue on the Kubernetes project](https://github.com/kubernetes/kubernetes/issues/65481)). This means it cannot be built in Builder at this time. You will need to manually build it on a workstation with at least 8 GB of RAM then upload it to Builder from your workstation.

The Kubernetes plan provides the Kubernetes binaries for controller and worker
nodes. It can be used as a base for custom plans and serves as a base package
for the `karate/kubernetes-*` subpackages, i.e.

* kubernetes-apiserver
* kubernetes-controller-manager
* kubernetes-scheduler
* kubernetes-kubelet
* kubernetes-proxy

To setup Kubernetes with Dojo, each of the subpackages / Kubernetes
components need to be loaded and configured individually. As Kubernetes
configuration is fairly complex and very environment specific, we don't attempt
to provide instructions here. A great guide to get started it "Kubernetes
The Hard Way": https://github.com/kelseyhightower/kubernetes-the-hard-way

