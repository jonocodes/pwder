#!/usr/bin/env bash

set -xe

docker build . -f caddy.Dockerfile -t pwder

docker run -it --rm --name pwder -p 80:80 pwder
