# Use PHP 8.3 with Apache
FROM php:8.3-apache

# Instala extensiones necesarias
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_sqlite

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Copiar el proyecto
COPY . /var/www/html

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Permisos para storage y cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Exponer puerto 8080
EXPOSE 8080

# Start Apache
CMD ["apache2-foreground"]
