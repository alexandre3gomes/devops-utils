#!/bin/sh
echo "Updating apt packages"
apt-get update && apt-get upgrade -y
echo "Installing docker"
apt-get install -y docker.io
echo "Waiting docker start up"
sleep 20s
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
echo "Downloading calico manifest"
wget https://docs.projectcalico.org/manifests/calico.yaml
echo "Adding internal dns k8smaster"
echo "$(hostname -I | awk '{print $1}') k8smaster" >> /etc/hosts
echo "Initialazing kubernetes control plane"
kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out
echo "Creating config folder to configured user"
mkdir -p $1/.kube
echo "Copying configuaration file from root"
cp -i /etc/kubernetes/admin.conf $1/.kube/config
echo "Adjusting permissions of configuration files"
chown $(id -u):$(id -g) $1/.kube/config
echo "Applying calico manifests"
kubectl apply -f calico.yaml
echo "Finished installation"
echo "Remove taint from master node"
kubectl taint nodes --all node-role.kubernetes.io/master