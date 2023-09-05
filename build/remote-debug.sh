#!/bin/bash

set -ex

# the workdir of the container
cd /app

cd cmd
dlv \
  --listen=:32100 \
  --headless=true \
  --api-version=2 \
  debug
