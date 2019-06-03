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
RUN /opt/google-cloud-sdk/bin/gcloud components install kubectl -q --no-user-output-enabled

## Install Vault
ARG VAULT_VERSION="1.1.2"
RUN wget -q -O vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip vault.zip -d /usr/local/bin \
    && rm -rf vault.zip

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
