FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libsqlite3-dev unzip git \
    && docker-php-ext-install pdo pdo_sqlite \
    && a2enmod rewrite

COPY . /var/www/html
WORKDIR /var/www/html
RUN chown -R www-data:www-data storage bootstrap/cache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080
CMD ["apache2-foreground"]
