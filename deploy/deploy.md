# Notes for deployment

Github/Dockerhub automatically build images from commits, so there is no need to docker push.

The following commands are run on the host server.


git clone https://github.com/jonocodes/pwder.git
cd pwder
git checkout <branch>

# first time setup

docker build -t pwder .

mkdir $HOME/.caddy
docker swarm init --advertise-addr $(hostname -i)

# first deploy

or curl instead of using git

curl https://raw.githubusercontent.com/jonocodes/pwder/do/docker-compose.yml > pwder-stack.yml

docker stack deploy --compose-file docker-compose.yml pwder

sleep 3

docker service ls

curl localhost/status


# update deploys, now in update.sh

docker pull jonocodes/pwder
docker service update --force --image pwder pwder_pwder --detach=false


# take down

docker stack rm pwder

# scale

docker service scale pwder_pwder=5
