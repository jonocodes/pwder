#!/usr/bin/env bash

cat << EOF
git_branch: $(git rev-parse --abbrev-ref HEAD)
git_checksum: $(git rev-parse HEAD)
build_date: $(date)
EOF
