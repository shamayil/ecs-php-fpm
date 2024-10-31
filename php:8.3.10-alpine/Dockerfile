# Use the official PHP image with FPM and Alpine Linux
FROM php:8.3.10-fpm-alpine3.20

# Set the timezone to Europe/London
ENV TZ=Europe/London
RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apk del tzdata

# Install dependencies
RUN apk update && apk add --no-cache \
    busybox \
    dcron \
    sudo \
    curl \
    nano \
    git \
    gmp-dev \
    postgresql-dev \
    docker-cli \
    linux-headers \
    autoconf \
    g++ \
    make \
    zlib-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libxml2-dev \
    imagemagick-dev

# Install PHP extensions
RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo_mysql \
        pdo_pgsql \
        soap \
        sockets \
        xml \
        gmp

# Clone the latest imagick version and install it
RUN git clone https://github.com/Imagick/imagick.git /tmp/imagick \
    && cd /tmp/imagick \
    && git checkout master \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable imagick \
    && rm -rf /tmp/imagick

# Install Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Cleanup
RUN rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/doc

# Set up cron
RUN echo '* * * * * root echo "Hello from cron" >> /var/log/cron.log 2>&1' > /etc/crontabs/root

# Create log file for cron
RUN touch /var/log/cron.log

# Set up working directory
WORKDIR /var/www/html

# Command to run cron in the background and php-fpm
CMD ["sh", "-c", "crond && php-fpm"]

# Expose port 9000 and start PHP-FPM
EXPOSE 9000
