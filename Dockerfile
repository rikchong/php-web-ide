FROM php:7.2-fpm

COPY run-server-and-fpm.sh /usr/bin/run-server-and-fpm.sh

RUN cd /usr/local && mkdir -pv /usr/share/man/man1 \
  && curl -sL https://github.com/cdr/code-server/releases/download/1.1140-vsc1.33.1/code-server1.1140-vsc1.33.1-linux-x64.tar.gz -o - | tar xvz && ln -s `pwd`/code-server1.1140-vsc1.33.1-linux-x64/code-server /usr/local/bin \ 
  && chmod a+x /usr/local/bin/code-server && chmod a+x /usr/bin/run-server-and-fpm.sh \
  && apt-get update && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y --no-install-recommends \
    libfreetype6-dev libssl-dev apt-utils libxslt-dev \
    libjpeg62-turbo-dev libpng-dev libxml2-dev software-properties-common \
    libmemcached-dev zlib1g-dev libicu-dev g++ libmcrypt-dev \
    curl libcurl4-openssl-dev subversion libtidy-dev openjdk-8-jdk-headless \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db \
  && add-apt-repository 'deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/debian wheezy main' \
  && apt-get -y install nodejs mariadb-client \
  && curl -L https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.1.4/flyway-commandline-5.1.4-linux-x64.tar.gz -o - | tar xvz && ln -s `pwd`/flyway-5.1.4/flyway /usr/local/bin \
  && curl -L http://www-us.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz -o - | tar xvz && ln -s `pwd`/apache-maven-3.6.1/bin/mvn /usr/local/bin \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-install -j$(nproc) calendar \
  && docker-php-ext-install -j$(nproc) exif \
  && docker-php-ext-install -j$(nproc) gettext \
  && docker-php-ext-install -j$(nproc) intl \
  && docker-php-ext-install -j$(nproc) pdo_mysql \
  && docker-php-ext-install -j$(nproc) pcntl \
  && docker-php-ext-install -j$(nproc) soap \
  && docker-php-ext-install -j$(nproc) sockets \
  && docker-php-ext-install -j$(nproc) sysvmsg \
  && docker-php-ext-install -j$(nproc) sysvsem \
  && docker-php-ext-install -j$(nproc) sysvshm \
  && docker-php-ext-install -j$(nproc) tidy \
  && docker-php-ext-install -j$(nproc) wddx \
  && docker-php-ext-install -j$(nproc) zip \
  && docker-php-ext-install -j$(nproc) xsl \
  && docker-php-ext-install -j$(nproc) opcache \
  && pecl install redis-4.0.1 \
  && pecl install xdebug-2.6.0 \
  && pecl install mcrypt-1.0.2 \
  && docker-php-ext-enable redis xdebug mcrypt \
  && pecl install memcached-3.1.3 \
  && docker-php-ext-enable memcached \
  && echo "xdebug.remote_enable = true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_autostart = true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_host = localhost" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_port = 8000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_log = /var/log/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.max_nesting_level = 1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

ENTRYPOINT ["run-server-and-fpm.sh"]
