# Certbot

Install certbot
`apt install certbot`

Create wildcard certificate

`certbot -d *.finances-easy.com   --manual --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory`

Create root certificate
`certbot -d finances-easy.com   --manual --preferred-challenges dns certonly --server https://acme-v02.api.letsencrypt.org/directory`

Generate wildcard pem file to haproxy
`cat /etc/letsencrypt/live/finances-easy.com/fullchain.pem /etc/letsencrypt/live/finances-easy.com/privkey.pem > /etc/ssl/private/sub-finances-easy.com.pem`

Generate root pen file to haproxy
`cat /etc/letsencrypt/live/finances-easy.com-0001/fullchain.pem /etc/letsencrypt/live/finances-easy.com-0001/privkey.pem > /etc/ssl/private/root-finances-easy.com.pem`

# Configuration steps of nginx ingress controller
Click here [Nginx Ingress Controller] (https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/)

# Kubernetes scripts
k8smaster.sh should be ran in master node.
kubeadm-config.yaml should be used to kubeadm init, edit apiServer: certSANs with current ip's of master node.
k8sworker.sh should be ran in any workers to join the cluster.