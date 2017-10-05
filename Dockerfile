FROM ruby:2.4-alpine

MAINTAINER Jono Finger <jono@foodnotblogs.com>

ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN apk --no-cache add build-base && \
    bundle install && \
    apk del build-base

COPY . $APP_HOME

CMD ["ruby", "app.rb"]
