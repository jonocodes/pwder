#!/usr/bin/env bash

# This script runs the app in dev mode so it can be worked on

set -xe

docker build -t pwder .

echo Starting PWDer at http://localhost:4567
echo sample http://localhost:4567/gh/jonocodes/pwder/master/examples/hello.md

docker run --rm -p 4567:4567 --name pwder -v $PWD:/app \
  -e PWDER_HERE_DIR=/pwder_here \
  -v ${PWDER_HERE_DIR:=$PWD/examples}:/pwder_here \
  pwder rerun --background ruby app.rb
