#!/usr/bin/env bash

set -x
set -o

docker build . -f caddy.Dockerfile -t jonocodes/pwder:caddy
docker push jonocodes/pwder

hyper stop pwder
hyper rm pwder
# hyper rmi pwder
# hyper run -d --name pwder -p 80:80 -p 443:443 jonocodes/pwder:caddy


hyper compose down
hyper compose up -f hyper-compose.yml -d
