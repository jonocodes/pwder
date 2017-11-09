#!/usr/bin/env bash

# This script checks dockerhub for a newer instance of the image and uses it to update the running instance.
#
# This should be run on the swarm manager that runs pwder perhaps using cron.
# For example: */2 * * * * BRANCH=master update.sh

function log {
	echo $(date +'%D %r') = $1 >> $HOME/pwder_deploy.log
}

[ -z $BRANCH ] && BRANCH=master

# TODO: if in git repo, git pull and recall itself incase this file changes

IMAGE=jonocodes/pwder:$BRANCH

docker pull $IMAGE | grep "Status: Image is up to date" && {
	# log "image is up to date"
	exit 0
}

docker service ls | grep pwder_pwder || {
	log "service needs to be running before it can be updated"
	exit 1
}

log $(docker service update --force --image $IMAGE pwder_pwder_$BRANCH --detach=false)

log "updated $IMAGE"

# TODO: automate check, alert, rollback?
