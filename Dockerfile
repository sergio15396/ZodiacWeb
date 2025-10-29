# Imagen base con PHP 8.3 y Apache
FROM php:8.3-apache

# Instalar dependencias necesarias y SQLite
RUN apt-get update && apt-get install -y libsqlite3-dev unzip git \
    && docker-php-ext-install pdo pdo_sqlite \
    && a2enmod rewrite

# Copiar proyecto al contenedor
COPY . /var/www/html
WORKDIR /var/www/html

# Instalar Composer y dependencias de Laravel
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Cambiar DocumentRoot a /public para Laravel
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Dar permisos correctos a storage y bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Evitar warning de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Exponer puerto que Railway mapea
ENV PORT=8080
EXPOSE 8080

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]
