FROM php:7.2-fpm-buster

ENV MEMORY_LIMIT '64M'
ENV UPLOAD_MAX_SIZE '16M'
ENV MAX_EXECUTION_TIME '120'
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PM_MAX_CHILDREN=5
ENV PM_START_SERVERS=2
ENV PM_MIN_SPARE_SERVERS=1
ENV PM_MAX_SPARE_SERVERS=3
# Set environment variables
ARG TZ=Europe/London
ENV TZ ${TZ}


RUN apt-get update && apt-get upgrade -y --no-install-recommends

# install the PHP extensions
RUN apt-get install -y --no-install-recommends\
        libfreetype6-dev libjpeg-dev libpng-dev libpq-dev libbz2-dev \
        libzip-dev libxml2-dev libtidy-dev libxslt-dev libc-client-dev \
        libkrb5-dev libcurl4-openssl-dev libmemcached-dev libmagickwand-dev \
        libjpeg62-turbo-dev libmcrypt-dev libgd-dev libonig-dev libssl-dev \
        libgmp-dev libmhash-dev imagemagick zlib1g-dev wget cron unzip file \
        supervisor sudo vim curl nano git jpegoptim optipng pngquant gifsicle

RUN docker-php-ext-configure gmp \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include --with-freetype-dir=/usr/include/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl

# install the PHP extensions to docker
RUN docker-php-ext-install -j$(nproc) \
        gd opcache pdo_mysql pdo_pgsql mysqli zip soap bcmath bz2 calendar exif gettext \
        intl sockets sysvmsg sysvsem sysvshm tidy xsl xml mbstring json gmp imap \
        iconv phar session simplexml xmlrpc

RUN pecl install \
        redis imagick

RUN docker-php-ext-enable \
        imagick redis redis.so mysqli opcache

# define timezone
RUN echo "date.timezone = $TZ" > /usr/local/etc/php/conf.d/timezone.ini
# Set the timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy and Run Composer
COPY ./scripts ./scripts
RUN chmod +rx ./scripts/*.sh
RUN ./scripts/composer.sh
RUN ./scripts/entrypoint.sh

# Cleanup all downloaded packages
RUN apt-get -y autoclean  \
    && apt-get -y autoremove  \
    && apt-get -y clean  \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /tmp/* \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /usr/src/* \
    && rm -rf /var/log/* \
    && apt-get update

CMD ["php-fpm"]

EXPOSE 9000