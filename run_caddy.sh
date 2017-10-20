#!/usr/bin/env bash

set -xe

# sleep 3
#
# curl localhost/status


# swarm version

# first time setup

mkdir $HOME/.caddy
docker swarm init --advertise-addr $(hostname -i)

# first deploy

docker stack deploy --compose-file docker-compose.yml pwder

# update deploys
scale 2
docker pull jonocodes/pwder
docker service update pwder_pwder
scale 1
