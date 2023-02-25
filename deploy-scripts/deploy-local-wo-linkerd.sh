#!/bin/sh
set -ex

function install_kind() {
    echo 'kind is not installed, trying to install through "go install"'
    go version || (echo "go is not installed, cant install kind \n either \n \t install kind \n \t install go to install kind locally for this project \n \t or provide a cluster with nginx ingress controller and run \`docker build -t echohostname image/ && kubectl apply -k k8s/\`"; exit 1)
    mkdir -p tmp/
    export GOPATH=$PWD/tmp/ 
    go install sigs.k8s.io/kind@v0.17.0
    export PATH=$PATH:$PWD/tmp/bin
}

function create_cluster() {
    # create cluster if not exist
    kind get clusters | grep echohostname || (
        kind create cluster --name echohostname --config ./deploy-scripts/cluster.yaml --wait 60s
    )
}

# try to install kind if doesnt exist
kind version || install_kind

create_cluster

# install nginx ingress controller
kubectl --context kind-echohostname apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml 
# wait ingress controller to be up
kubectl --context kind-echohostname wait --namespace ingress-nginx --selector=app.kubernetes.io/component=controller --timeout=90s --for=condition=ready pod

# build and load service image
docker build -t barankaraaslan/echohostname image/
kind load docker-image barankaraaslan/echohostname --name echohostname

# deploy service
kubectl --context kind-echohostname apply -k k8s/local

echo 'You can query the service from http://localhost:12346. It uses port 12346 to reduce the possibilty of ports clashing with existing proccesses on the system'

echo 'SUCCESS'