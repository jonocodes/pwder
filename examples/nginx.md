---
title: "Play with Nginx"
terms: 2
---

This is a demo for [PWDer](http://github.com/jonocodes/pwder).

## Introduction

Play with Docker does not mean you have to use Docker yourself. In this example we will bring up an Nginx service without playing with any containers or virtualization. You can treat PWD as a base to demo any Linux service.

Click the text blocks to execute the commands automatically.

## Install

The base OS used by PWD is Alpine Linux, so here will will use *apk* to install Nginx.

```.term1
apk --update add nginx
mkdir /run/nginx
```

## Setup

Set up a basic 'hello world' config.

```.term1
cat <<EOF > /etc/nginx/conf.d/default.conf
server {
  listen 80;

  location = /hello {
    default_type text/html;
    return 200 "<h1>Hello world!</h1>";
  }
}
EOF
```

Start the service in the foreground, so we can easily stop it if needed.

```.term1
nginx -g "daemon off;"
```

## Test

Now lets see if it node2 can curl Nginx on node1
```.term2
curl -i http://node1/hello
```

Expected output:
```
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html
Content-Length: 21
Connection: keep-alive

<h1>Hello world!</h1>
```

[Or visit node1 in a browser](/hello){:data-term=".term1"}{:data-port="80"}


## Nginx in Ubuntu

Not everyone is comfortable with Alpine Linux, so lets try using a different distro. Fortunately Docker makes it very easy to use a different Linux distribution. OK, I lied above. We are going to use Docker here, but only a single line of it.

Lets will start an Ubuntu container and go inside it.

```.term2
docker run -it --net=host ubuntu:16.04 bash
```

Now that we are inside Ubuntu we can use *apt* to install packages like you are used to.

```.term2
apt update
apt install -y curl nginx
```

Start Nginx

```.term2
service nginx start

curl -i http://node2
```

[And visit node2 in a browser](/){:data-term=".term2"}{:data-port="80"}
