#!/usr/bin/env bash

set -x
set -o

docker build . -t jonocodes/pwder
docker push jonocodes/pwder

# run run_caddy.sh on server
