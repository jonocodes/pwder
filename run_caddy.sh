#!/usr/bin/env bash

set -xe

docker inspect pwder_nw || docker network create --driver bridge pwder_nw

docker ps|grep caddy || {
  docker run --name caddy --restart=always --network=pwder_nw \
    -v $(pwd)/Caddyfile:/etc/Caddyfile \
    -v $HOME/.caddy:/root/.caddy \
    -p 80:80 -p 443:443 \
    abiosoft/caddy
}

# TODO: use swarm to roll out update instead

docker inspect pwder && docker stop pwder && docker rm pwder

docker run -d --restart=always --name pwder --network=pwder_nw pwder

docker ps

sleep 3

curl localhost/status
