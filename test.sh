#!/usr/bin/env bash

set -xe

docker build -t pwder_test .

docker run --rm pwder_test bundle exec rspec
