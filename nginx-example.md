---
title: "Play with Nginx"
terms: 2
---

This is a demo for [PWDer](http://github.com/jonocodes/pwder).

## Introduction

Play with Docker does not mean you have to use Docker yourself. In this example we will bring up an Nginx service without playing with any containers or virtualization. You can treat PWD as a base to demo any Linux service.

Click the text blocks to execute the commands automatically on the right terminals.

## Install

The base OS we are using is Alpine Linux, so here will will use apk to install Nginx.

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

# Test

Now lets see if it node2 can curl Nginx on node1
```.term2
curl -i http://node1/hello
```

Expected output

```
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html
Content-Length: 21
Connection: keep-alive

<h1>Hello world!</h1>
```

[Or visit it in a browser](/hello){:data-term=".term1"}{:data-port="80"}
