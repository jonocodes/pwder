#!/usr/bin/env bash

cat << EOF
git_branch: $(git rev-parse --abbrev-ref HEAD)
git_checksum: $(git rev-parse HEAD)
build_date: $(date)
EOF

# HACK: since git_branch above always returns HEAD for every branch on travis
[ -z $TRAVIS_BRANCH ] || echo travis_branch: $TRAVIS_BRANCH
