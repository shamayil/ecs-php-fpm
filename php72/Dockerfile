FROM php:7.2-fpm-buster

ENV TIMEZONE 'Europe/London'
ENV MEMORY_LIMIT '64M'
ENV UPLOAD_MAX_SIZE '16M'
ENV MAX_EXECUTION_TIME '120'

RUN apt-get update && apt-get install -y cron --no-install-recommends

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        libbz2-dev \
        libzip-dev \
        libxml2-dev \
        libtidy-dev \
        libxslt-dev \
        libmemcached-dev \
        libmagickwand-dev \
    ; \
    docker-php-ext-configure gd \
            --with-jpeg-dir=/usr/include \
            --with-freetype-dir=/usr/include/; \
    \
	set -ex && \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		soap \
		bcmath \
		bz2 \
		calendar \
		exif \
		gettext \
		intl \
		sockets \
		sysvmsg \
		sysvsem \
		sysvshm \
		tidy \
		xsl \
	; \
    pecl install imagick && docker-php-ext-enable imagick; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# install redis extention
RUN pecl install redis; \
    docker-php-ext-enable redis.so

# install mysqli extention
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# define timezone \
RUN echo "date.timezone = ${TIMEZONE}" > /usr/local/etc/php/conf.d/timezone.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000
