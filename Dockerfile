FROM debian:latest

ENV GOROOT  /gosource
ENV GOPATH  /go
ENV PATH    $GOPATH/bin:$GOROOT/bin:$PATH

ARG VAULT_VERSION
ARG VAULT_ETHEREUM_VERSION
ARG VAULT_UI
ARG GO_VERSION

ADD   ${VAULT_ETH_PATH} ${GOPATH}/github.com/immutability-io/vault-ethereum
RUN  apt-get update
RUN   apt-get install -y build-essential git wget curl
RUN   curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN   echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN   apt-get update
RUN   apt-get install -y yarn npm
RUN   wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
RUN   tar -xvf go${GO_VERSION}.linux-amd64.tar.gz
RUN   mv go /gosource
RUN   git clone --branch $VAULT_VERSION https://github.com/hashicorp/vault.git
RUN   cd vault \
&&    mkdir -p pkg/web_ui \
&&    make bootstrap    \
&&    if [ "$VAULT_UI" = "true" ]; then make static-dist && make dev-ui; else make dev; fi
RUN   mkdir -p ${GOPATH}/github.com/immutability-io
RUN   cd ${GOPATH}/github.com/immutability-io    \
&&    git clone --branch ${VAULT_ETHEREUM_VERSION} https://github.com/ticket721/vault-ethereum.git    \
&&    cd vault-ethereum    \
&&    go install
RUN   cp ${GOPATH}/bin/vault-ethereum /vault/plugins/

FROM debian:latest

RUN mkdir /vault          \
&&  mkdir /vault/config   \
&&  mkdir /vault/plugins  \
&&  mkdir /vault/file     \
&&  mkdir /vault/logs

COPY  --from=0  /go/bin/vault-ethereum  /vault/plugins
COPY  --from=0  /go/bin/vault           /bin
COPY            init_dev.sh                 /vault/init_dev.sh
COPY            entrypoint.sh                 /vault/entrypoint.sh
COPY            devconfig.hcl                 /vault/config/devconfig.hcl
RUN   chmod +x /vault/init_dev.sh
RUN   chmod +x /vault/entrypoint.sh
ENTRYPOINT ["/vault/entrypoint.sh"]

