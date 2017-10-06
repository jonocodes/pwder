---
title: "Hello World!"
terms: 2
---

This is a demo for [PWDer](http://github.com/jonocodes/pwder).

[![Make document interactive using pwder.io](https://img.shields.io/badge/make%20doc%20interactive-with%20pwder.io-orange.svg)](http://localhost:4567/pwderify)

[![one](https://raw.githubusercontent.com/jonocodes/pwder/master/static/pwderif.svg?raw=true)](http://localhost:4567/pwderify)

[![two](https://raw.githubusercontent.com/jonocodes/pwder/master/static/pwderif.png)](http://localhost:4567/pwderify)

[![three](https://travis-ci.org/openfaas/faas.svg?branch=master)](https://travis-ci.org/openfaas/faas)

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
