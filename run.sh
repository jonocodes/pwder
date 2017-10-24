#!/usr/bin/env bash

# This script runs the app in dev mode so it can be worked on

set -xe

# echo -e "git_branch: $(git rev-parse --abbrev-ref HEAD)\ngit_checksum: $(git rev-parse HEAD)\nbuild_date: $(date)" > build_info.yml

# cat > build_info.yml <<- EOF
# git_branch: $(git rev-parse --abbrev-ref HEAD)
# git_checksum: $(git rev-parse HEAD)
# build_date: $(date)
# EOF

# printf "%s\n" "git_branch: $(git rev-parse --abbrev-ref HEAD)" "git_checksum: $(git rev-parse HEAD)" "build_date: $(date)" > build_info.yml

deploy/build_info.sh > build_info.yml

# cat build_info.yml

docker build -t pwder .

echo Starting PWDer at http://localhost:4567
echo sample http://localhost:4567/gh/jonocodes/pwder/master/examples/hello.md

docker run --rm -p 4567:4567 --name pwder -v $PWD:/app \
  -e PWDER_HERE_DIR=/pwder_here \
  -v ${PWDER_HERE_DIR:=$PWD/examples}:/pwder_here \
  pwder rerun --background ruby app.rb


# testing
# docker run --rm -v $PWD:/app pwder rspec
