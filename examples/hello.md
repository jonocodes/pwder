---
title: "Hello World!"
terms: 2
---

This is a demo for [PWDer](http://github.com/jonocodes/pwder).

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
