FROM ruby:2.4-alpine

MAINTAINER Jono Finger <jono@foodnotblogs.com>

RUN apk --no-cache add tini git openssh-client && \
    apk --no-cache add --virtual devs tar curl && \
    curl "https://caddyserver.com/download/linux/amd64?license=personal" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy && \
    apk del devs

ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN apk --no-cache add build-base libxslt-dev && \
    bundle config --global build.nokogiri "--use-system-libraries" && \
    bundle install && \
    apk del build-base

COPY ./Caddyfile /etc/Caddyfile

COPY . $APP_HOME

CMD rackup -p 4567 -E production -D && caddy -conf /etc/Caddyfile
