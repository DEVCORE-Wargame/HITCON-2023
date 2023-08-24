FROM php:7.4-apache

RUN a2enmod rewrite
RUN a2enmod remoteip
COPY apache2/remoteip.conf /etc/apache2/conf-available/remoteip.conf
RUN a2enconf remoteip
RUN service apache2 restart

#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN docker-php-ext-install mysqli

COPY www/ /var/www/html/
RUN chown root:root -R /var/www/html && chmod go-w -R /var/www/html && chmod ugo+r /var/www/html/index.php

