FROM ruby:2.7.2-alpine

# 文字コードの設定
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LC_CTYPE="utf-8"

# 環境変数
ENV APP="/kanra-club-server" \
    CONTAINER_ROOT="./" \
    NOKOGIRI_OPTION="--use-system-libraries \
                     --with-xml2-config=/usr/bin/xml2-config \
                     --with-xslt-config=/usr/bin/xslt-config" \
    MYSQL_PORT=3307\
    SERVER_PORT=3000

# ライブラリのインストール(追加したい場合は以下に追記)
RUN apk update \
 && apk upgrade --no-cache \
 && apk add --update --no-cache \
            alpine-sdk \
            bash \
            bind-tools \
            jq \
            less \
            libgcrypt-dev \
            libxml2-dev \
            libxslt-dev \
            mariadb-dev \
            mysql-client \
            nodejs \
            tzdata \
            xvfb \
 && apk add --update --no-cache --virtual .build-dependencies \
            build-base \
            wget \
            yaml-dev \
            zlib-dev \
 && gem install -q -N bundler -v 2.1.4 \
 && gem install -q -N pkg-config \
 && gem install -q sprockets -v 4.0.0 \
 && gem install -q -N rails -v 6.0.3.1 \
 && gem install -q -N nokogiri -v 1.10.7 -- $NOKOGIRI_OPTION \
 && gem install -q -N mysql2 -v 0.5.3 \
 && apk del .build-dependencies \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# 実行するディレクトリの指定
WORKDIR $APP
COPY Gemfile Gemfile.lock $CONTAINER_ROOT
RUN bundle install --jobs=4 --retry=9

ENV RAILS_SERVE_STATIC_FILES=true \
    PORT=$SERVER_PORT \
    TERM=xterm

EXPOSE $SERVER_PORT
EXPOSE $MYSQL_PORT
