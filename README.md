# PWDer

Showcase fully interactive demos of your open source project by only writing markdown.

Everything is run in the browser. Under the hood *Play with Docker* is used to spin up machine instances so users dont need to install anything.

![PWDer in action](https://raw.githubusercontent.com/jonocodes/pwder/master/screenshot.png?raw=true "Title")

## Purpose

[Play with Docker](http://labs.play-with-docker.com/) is a fantastic tool for spinning up Docker nodes in a browser for learning and testing your Docker knowledge.

The [Play with Docker classroom](http://training.play-with-docker.com/) is also a great resource that provides canned tutorials to showcase different Docker features and integrations.

If you want to showcase your own application there is not a simple way to do it. You could either write the HTML/Javascript yourself to make use of the [PWD Javascript SDK](https://github.com/play-with-docker/sdk) or you could [fork the classroom repo](https://github.com/play-with-docker/play-with-docker.github.io) and host a copy of that.

PWD-er simplifies this for you by rendering the markdown into a template for you as needed. No Jekyll precompilation necessary. Just post a Markdown readme that [follows the writing guide]((https://github.com/play-with-docker/play-with-docker.github.io/blob/master/writing-tutorials.md) to your public repo and point to it with PWD-er.

## Example Use

A Docker 'hello world'

http://pwder.io/?doc=https://raw.githubusercontent.com/jonocodes/pwder/master/hello-example.md

or use shorthand for content hosted on github:

http://pwder.io/gh/jonocodes/pwder/master/hello-example.md

An Nginx 'hello world' without Docker

http://pwder.io/gh/jonocodes/pwder/master/nginx-example.md

## Parameters

**doc** (required) - URL path to a publicly accessible Markdown demo for your project. It should follow the format described in the [PWD guide for writing tutorials](https://github.com/play-with-docker/play-with-docker.github.io/blob/master/writing-tutorials.md)

example: /?doc=https://raw.githubusercontent.com/jonocodes/pwder/master/hello-example.md

Optionally you can substitute */?doc=https://raw.githubusercontent.com/* with */gh/*

example:
/gh/jonocodes/pwder/master/hello-example.md

**template** (optional) - URL path for a [Liquid](https://shopify.github.io/liquid/) template that your markdown will be rendered into. If you want to do this, its probably best to copy default.html and make modifications to that.

example: /gh/jonocodes/pwder/master/hello-example.md&template=https://raw.githubusercontent.com/jonocodes/pwder/master/default.html

**(front matter parameters)** (optional) - These can be used to override values specified in the front matter. For example you can specify values for 'title' or 'terms'.

example:
/gh/jonocodes/pwder/master/hello-example.md?terms=0&title=Sample


## Development

    bundle install
    rerun 'ruby app.rb'

or run with Docker

    docker build -t pwder .
    docker run -p 4567:4567 pwder

Visit http://localhost:4567/gh/jonocodes/pwder/master/hello-example.md

or http://localhost:4567/gh/play-with-docker/play-with-docker.github.io/master/_posts/2017-03-31-traefik-load-balancing.markdown

## TODO

* It would be cool to get this working entirely in browser instead of relying on a web service. I briefly tried to get strapdown and kramed to render GFM but it could use a little work.

* Figure out a way to keep up to date with upstream Jekyll theme better.

* Have other ideas? Please open a ticket or PR. Thanks.
