FROM php:8.3-apache

RUN apt-get update && apt-get install -y libsqlite3-dev unzip git \
    && docker-php-ext-install pdo pdo_sqlite \
    && a2enmod rewrite

# Copiar proyecto primero
COPY . /var/www/html
WORKDIR /var/www/html

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# DocumentRoot a public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Permisos
RUN chown -R www-data:www-data storage bootstrap/cache

# Evitar warning Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Puerto
ENV PORT=8080
EXPOSE 8080

CMD ["apache2-foreground"]
