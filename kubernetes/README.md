# Kubernetes scripts
k8smaster.sh should be ran in master node.
kubeadm-config.yaml should be used to kubeadm init, edit apiServer: certSANs with current ip's of master node.
k8sworker.sh should be ran in any workers to join the cluster.

# Configuration steps of nginx ingress controller
Click here [Nginx Ingress Controller] (https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/)