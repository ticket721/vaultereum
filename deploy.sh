#! /bin/bash

VAULT_VERSION="v1.3.2"
VAULT_ETHEREUM_VERSION="fix-accept-hex-encoding-on-accounts-sign"
GO_VERSION="1.12.7"

docker build -t vaultereum \
--build-arg VAULT_VERSION=${VAULT_VERSION} \
--build-arg VAULT_ETHEREUM_VERSION=${VAULT_ETHEREUM_VERSION} \
--build-arg GO_VERSION=${GO_VERSION} \
--build-arg VAULT_UI=false \
.

docker login --username=${DOCKER_USERNAME} --password=${DOCKER_PASSWORD}

docker tag vaultereum ticket721/vaultereum:go-${GO_VERSION}_vault-${VAULT_VERSION}_ve-${VAULT_ETHEREUM_VERSION}

docker push ticket721/vaultereum:go-${GO_VERSION}_vault-${VAULT_VERSION}_ve-${VAULT_ETHEREUM_VERSION}

