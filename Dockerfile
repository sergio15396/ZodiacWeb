# Imagen base con PHP 8.3 y Apache
FROM php:8.3-apache

# Instalar dependencias necesarias y SQLite
RUN apt-get update && apt-get install -y \
    libsqlite3-dev unzip git \
    && docker-php-ext-install pdo pdo_sqlite \
    && a2enmod rewrite

# Copiar el proyecto al contenedor
COPY . /var/www/html
WORKDIR /var/www/html

# Cambiar DocumentRoot a /public para Laravel
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Dar permisos correctos a storage y bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Exponer puerto 8080 (Railway lo mapea automáticamente)
EXPOSE 8080

# Comando para iniciar Apache
CMD ["apache2-foreground"]
