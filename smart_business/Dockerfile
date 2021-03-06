ARG RUBY_VERSION=2.7.1
FROM ruby:$RUBY_VERSION-alpine

ARG BUNDLER_VERSION=2.1.4

ENV PROJECT_ROOT=/app \
    WD_INSTALL_DIR=/home/webdrivers \
    LANG=C.UTF-8
RUN mkdir -p ${PROJECT_ROOT}
WORKDIR $PROJECT_ROOT

RUN apk add -u --no-cache --progress openssl --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main && \
    apk add --no-cache --progress \
            ca-certificates build-base icu-libs postgresql-dev nodejs-current npm cmake \
            chromium chromium-chromedriver postgresql-client && \
    apk add -u --no-cache --progress wkhtmltopdf --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    tzdata

RUN gem install bundler:${BUNDLER_VERSION}

COPY Gemfile* $PROJECT_ROOT/
RUN bundle check || \
    CFLAGS="-Wno-cast-function-type" \
    BUNDLE_FORCE_RUBY_PLATFORM=1 \
    bundle install --jobs 4 --retry 4
# Temporary solution to work with chromedriver
RUN mkdir /home/webdrivers && ln -s /usr/bin/chromedriver /home/webdrivers/chromedriver

RUN apk update \
    && apk add build-base \
       tzdata

COPY . .
RUN npm config set unsafe-perm true && npm install -g yarn
RUN yarn install