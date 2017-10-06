#!/usr/bin/env bash

docker build -t pwder .

docker run --rm -p 4567:4567 -v $PWD:/app \
  -e PWDER_HERE_DIR=/pwder_here \
  -v ${PWDER_HERE_DIR:=$PWD/examples}/examples:/pwder_here \
  pwder rerun --background ruby app.rb
