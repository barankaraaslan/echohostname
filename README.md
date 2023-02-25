# echohostname

- ## To build the image:

Image related files are stored in `image/`. Run `docker build -t barankaraaslan/echohostname image/`, there is a github action that automatically builds and deploys the image to dockerhub

- ## To deploy locally with `kind`:

`./deploy-scripts/deploy-local.sh`, this scripts creates a new kind clutster with nginx ingresscontroller (so it does not interfere with other dev clusters on the system), builds the image and deploys the service to the cluster. Then injects `linkerd` to it.
The script tries to install `kind` on a temporary folder so you dont have to install kind.

`./deploy-scripts/purge-local.sh` will delete the kind cluster that is created and removes the image built, and tools that are downloaded temporarily (`kind` and `linkerd`, dont worry, they are not installed system-wide. just downloaded to `./tmp/`)

This deployment uses port `12346` to not clash with other ingress controllers that might be already installed on the system

You can see the service running at `http://localhost:12346`

You can run `./tmp/bin/linkerd viz dashboard` to see networking in the cluster.

In case of something does not work with linkerd, please use `./deploy-scripts/deploy-local-wo-linkerd`. It deploys creates a kind cluster and deploys the service but without linkerd

- ## To deploy to an already existing cluster

k8s manifests provided uses nginx ingress, so the cluster must have nginx ingress controller installed. It can be deployed with `kubectl apply -k k8s/local`. There is an already built image of the service on dockerhub, so the image is not needed to be moved to the cluster.

- ## To deploy to `GCP`:

There is also ingress support for GCP, you can deploy to GCP with manifests in `k8s/gcp` directory by running `kubectl apply -k k8s/gcp`. There is an already deployed one at `http://34.160.232.16`, there is an github action that deploys the service to gcp
