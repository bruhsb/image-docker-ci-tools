# gcloud-k8s-helm

## intro

A pretty basic Docker image, `FROM google/cloud-sdk`, additionally with `kubectl`
 and `helm` installed. 

Helm has [helm-gcs](https://github.com/nouney/helm-gcs) and 
[helm-bulk](https://github.com/ovotech/helm-bulk) plugins installed; "helm-gcs"
 to allow for use of a private helm repo in GCS and helm-bulk for taking backups
 of Helm releases.


## authing

There is no authing performed automatically in the image. This must be done via
 CLI where required.