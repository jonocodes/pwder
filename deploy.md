# Notes for deployment

git clone https://github.com/jonocodes/pwder.git
cd pwder
git checkout do

# first time setup

docker build -t pwder .

mkdir $HOME/.caddy
docker swarm init --advertise-addr $(hostname -i)

# first deploy

docker stack deploy --compose-file docker-compose.yml pwder

sleep 3

docker service ls

curl localhost/status


# update deploys
docker pull jonocodes/pwder
docker service update --image pwder pwder_pwder --detach=false


# take down

docker stack rm pwder
