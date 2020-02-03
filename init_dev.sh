#! /bin/bash

export SHASUM256_eth=$(sha256sum "/vault/plugins/vault-ethereum" | cut -d' ' -f1)

vault write -address=http://127.0.0.1:8200 sys/plugins/catalog/ethereum-plugin \
      sha_256="${SHASUM256_eth}" \
      command="vault-ethereum"

vault secrets enable -address=http://127.0.0.1:8200 -path=ethereum -description="Immutability's Ethereum Wallet" -plugin-name=ethereum-plugin plugin
