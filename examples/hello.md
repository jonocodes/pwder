---
title: "Hello World!"
terms: 1
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
docker pull nginx:alpine
docker run -d -p 84:80 nginx:alpine
```

Now lets see if it Nginx is up
```.term1
curl http://localhost:84
```

[Or visit it in a browser](/){:data-term=".term1"}{:data-port="84"}
