FROM php:8.1.3-fpm-alpine3.15

# RUN apk add --no-cache shadow openssl bash nodejs npm postgresql-dev git sqlite-dev
RUN apk add --no-cache shadow openssl bash nodejs npm postgresql-dev git sqlite-dev
RUN docker-php-ext-install bcmath pdo pdo_pgsql pdo_sqlite pdo_mysql

# Install redis
# RUN pecl install -o -f redis \
#     &&  rm -rf /tmp/pear \
#     &&  docker-php-ext-enable redis

RUN mkdir -p /usr/src/php/ext/redis; \
	curl -fsSL https://pecl.php.net/get/redis --ipv4 | tar xvz -C "/usr/src/php/ext/redis" --strip 1; \
	docker-php-ext-install redis;

# RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
#     && pecl install xdebug-3.1.5 \
#     && docker-php-ext-enable xdebug \
#     && apk del -f .build-deps

# Configure Xdebug
# RUN echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.log=/var/www/html/xdebug/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini    

RUN  apk add git 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN usermod -u 1000 www-data

WORKDIR /var/www

RUN rm -rf /var/www/html

RUN ln -s public html

USER www-data

EXPOSE 9000

ENTRYPOINT ["php-fpm"]
