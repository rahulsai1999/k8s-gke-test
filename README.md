## K8s GKE Testing

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
- build, tag and push images to Docker Hub
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
docker run -it -v ${pwd}:/app ruby:alpine sh

gem install travis --no-rdoc --no-ri
gem install travis

travis login

travis encrypt-file service-account.json

```