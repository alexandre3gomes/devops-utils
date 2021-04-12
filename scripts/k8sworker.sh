#!/bin/sh
echo "Updating apt packages"
apt-get update && apt-get upgrade -y
echo "Installing docker"
apt-get install -y docker.io
echo "Adding kubernetes apt repo"
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
echo "Getting gpg key for kubernetes repo"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "Updating apt packages"
apt-get update
echo "Installing kubernetes packages (kubeadm, kubelet, kubectl)"
apt-get install -y kubeadm=1.20.4-00 kubelet=1.20.4-00 kubectl=1.20.4-00
echo "Marking kubernetes packages to hold version"
apt-mark hold kubelet kubeadm kubectl
echo "Worker dependencies has been installed"
echo "Add k8smaster PRIVATE_MASTER_IP in /etc/hosts"
echo "Run following command in master node to get join command"
echo "sudo kubeadm token create --print-join-command"
