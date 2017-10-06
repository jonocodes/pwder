#!/usr/bin/env bash

set -xe

docker build -t pwder .

echo Starting PWDer at http://localhost:4567

docker run --rm -p 4567:4567 -v $PWD:/app \
  -e PWDER_HERE_DIR=/pwder_here \
  -v ${PWDER_HERE_DIR:=$PWD/examples}:/pwder_here \
  pwder rerun --background ruby app.rb
