FROM hashicorp/terraform:light

RUN apk update && apk add ca-certificates && apk add openssl --update make ca-certificates openssl python \
    && update-ca-certificates && rm -rf /var/cache/apk/*

## Install Google Cloud SDK
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
    && tar zxvf google-cloud-sdk.tar.gz -C /opt\
    && rm -f google-cloud-sdk.tar.gz \
    && ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud \
    && /opt/google-cloud-sdk/install.sh --usage-reporting=false --path-update=true \
    && /opt/google-cloud-sdk/bin/gcloud --quiet components update

## Install kubectl
ARG KUBECTL_VERSION="v1.16.0"
RUN wget -q -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

## Install Vault
ARG VAULT_VERSION="1.1.2"
RUN wget -q -O vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip vault.zip -d /usr/local/bin \
    && rm -rf vault.zip

## Install kustomize
ARG KUSTOMIZE_VERSION="v3.4.0"

RUN wget -q https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -O - | tar -xzO kustomize > /usr/local/bin/kustomize \
    && chmod +x /usr/local/bin/kustomize

## Install Helm
ARG HELM_VERSION="v2.9.0"
RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

# Helm ENVs
ENV HELM_HOME /home/itsme/.helm/

# Create User for RUN
RUN adduser -S itsme itsme
USER itsme

# Helm install plugins
RUN helm init --client-only
