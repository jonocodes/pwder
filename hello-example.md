---
title: "Hello World!"
terms: 2
---

## Welcome
This is a demo for [PWDer](http://github.com/jonocodes/pwder).

## Prerequisites
There are no specific skills needed for this tutorial beyond a basic comfort with the command line and using a text editor. Prior experience in developing web applications will be helpful but is not required. As you proceed further along the tutorial, we'll make use of [Docker Cloud](https://cloud.docker.com/).

## Start a container

```.term1
docker container run hello-world
```

Expected output:
```
... hello world
```

Lets run NGINX
```.term1
docker run --name nginx -p 84:80 nginx
```

Now lets see if it node2 can ping Nginx on node1
```.term2
curl http://node1:84
```

[Or visit it in a browser](/){:data-term=".term1"}{:data-port="84"}
