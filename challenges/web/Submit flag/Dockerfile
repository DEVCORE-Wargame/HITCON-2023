FROM php:7.4.3-fpm

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN docker-php-ext-install pdo pdo_mysql

COPY www/ /var/www/html/
RUN chown root:root -R /var/www/html && chmod go-w -R /var/www/html && chmod ugo+r /var/www/html/
