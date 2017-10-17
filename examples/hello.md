---
title: "Hello World!"
terms: 2
---

[![Make document interactive using pwder.io](https://img.shields.io/badge/make%20doc%20interactive-with%20pwder.io-orange.svg)](http://pwder.io/?doc=https://github.com/jonocodes/pwder/blob/develop/examples/hello.md)

## Start a container

```.term1
docker container run hello-world
```
Expected output:
```
... Hello ...
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
