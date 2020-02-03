#! /bin/bash

set -m
vault $@ &
sleep 5

if [ "$1" == "server" ]; then
  if [ "$2" == "-dev" ]; then
    /vault/init_dev.sh
  else
    echo "Prod Ethereum Plugin"
  fi
fi

echo "!!VAULTEREUM STARTED!!"
fg
