FROM ruby:2.4-alpine

MAINTAINER Jono Finger <jono@foodnotblogs.com>

ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

HEALTHCHECK --interval=10s \
  CMD curl -f http://localhost:4567/status || exit 1

COPY Gemfile* $APP_HOME/

RUN apk --no-cache add curl libxslt-dev build-base && \
    bundle config --global build.nokogiri "--use-system-libraries" && \
    echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    bundle install && \
    apk del build-base

COPY . $APP_HOME

CMD ["ruby", "app.rb"]
