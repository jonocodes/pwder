#!/usr/bin/env bash

set -xe

docker build . -f caddy.Dockerfile -t pwder

docker run -it --rm --name pwder -p 80:80 -p 443:443 -p 4567:4567 pwder
