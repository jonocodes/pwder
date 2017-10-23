#!/usr/bin/env bash

# This script checks dockerhub for a newer instance of the image and uses it to update the running instance.
#
# This should be run on the swarm manager that runs pwder perhaps using cron.

function log {
	echo $(date +'%D %r') = $1 >> pwder_deploy.log
}

# TODO: if in git repo, git pull and recall itself incase this file changes

docker pull jonocodes/pwder:latest | grep "Status: Image is up to date" && {
	log "image is up to date"
	exit 0
}

docker service ls | grep pwder_pwder || {
	log "service needs to be running before it can be updated"
	exit 1
}

log $(docker service update --force --image pwder pwder_pwder --detach=false)

# TODO: automate check, alert, rollback?
