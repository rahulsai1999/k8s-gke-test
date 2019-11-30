## K8s GKE Testing

[![Build Status](https://travis-ci.com/rahulsai1999/k8s-gke-test.svg?branch=master)](https://travis-ci.com/rahulsai1999/k8s-gke-test)

### To deploy on local environment

```
kubectl apply -f ./k8s
```

### Travis workflow

- installs the GCloud SDK CLI
- auth info from the config file
- logs in to docker cli
- build the test version of the image and run tests
- if tests are successful run the deploy section
- build, tag and push images to Docker Hub (using Git SHA)
- Apply all the config on the k8s folder
- imperatively set latest image on deployment

### Service Account Workflow

- create service account and download the service account json file
- install travis cli
- encrypt and upload json file to account
- in travis.yml add code to decrypt and load it to gcloud

### Encryption Steps

* Copy the service-account.json file to the current working directory before proceeding

```
docker run -it -v ${pwd}:/app ruby:latest sh

gem install travis --no-rdoc --no-ri
gem install travis

travis login --pro

travis encrypt-file --pro service-acc.json --add
```

Delete the service-acc.json file from the directory 

### Gcloud Config - IMP

- Set secret for the Postgres password
```
kubectl create secret generic pgpassword --from-literal PGPASSWORD=mypgpass123
```
- Create RBAC permissions first
```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade
```
- Use helm to install the packages

```
helm install stable/nginx-ingress --name my-nginx --set rbac.create=true
```

### HTTPS setup

Manual Process

- The entrypoint domain sends a request to Let's Encrpyt to get a certificate
- Let's Encrypt sends the request to a random route of the server and gets a reply
- The certificate is provided for 90 days

Automatic Process

- Inside cloud shell

```
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml

kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.12.0 \
  jetstack/cert-manager
```

- Create an issuer file similar to a k8s config inside the k8s directory.
- Create an certificate file similar to a k8s config inside the k8s directory.