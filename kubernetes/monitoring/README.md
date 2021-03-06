Get token for access kubernetes dashboard:
`kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount admin-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode`

Install prometheus operator custom resources
`kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/master/bundle.yaml`

Create a Kubernetes Secret to store Grafana Cloud credentials
`kubectl create secret generic kubepromsecret --from-literal=username=54533 --from-literal=password='<grafana_cloud_api_key>'`