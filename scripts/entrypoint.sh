#!/bin/bash

# pm conf
sed -i "s/pm.max_children = 5/pm.max_children = ${PM_MAX_CHILDREN}/g" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.start_servers = 2/pm.start_servers = ${PM_START_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = ${PM_MIN_SPARE_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = ${PM_MAX_SPARE_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf

# php conf
echo "php_admin_value[memory_limit] = ${MEMORY_LIMIT}" >> /usr/local/etc/php-fpm.d/www.conf
echo "php_value[memory_limit] = ${MEMORY_LIMIT}" >> /usr/local/etc/php-fpm.d/www.conf
echo "php_value[post_max_size] = ${UPLOAD_MAX_SIZE}" >> /usr/local/etc/php-fpm.d/www.conf
echo "php_value[upload_max_filesize] = ${UPLOAD_MAX_SIZE}" >> /usr/local/etc/php-fpm.d/www.conf
echo "php_value[max_input_time] = ${MAX_EXECUTION_TIME}" >> /usr/local/etc/php-fpm.d/www.conf
echo "php_value[max_execution_time] = ${MAX_EXECUTION_TIME}" >> /usr/local/etc/php-fpm.d/www.conf

# opcache conf
echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
echo "opcache.max_accelerated_files=4000" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
echo "opcache.revalidate_freq=60" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/conf.d/opcache-recommended.ini
