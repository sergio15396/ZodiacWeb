# 1️⃣ Imagen base con PHP 8.3 y Apache
FROM php:8.3-apache

# 2️⃣ Instalar dependencias necesarias y SQLite
RUN apt-get update && apt-get install -y \
    libsqlite3-dev unzip git \
    && docker-php-ext-install pdo pdo_sqlite \
    && a2enmod rewrite

# 3️⃣ Configurar DocumentRoot a /public de Laravel
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# 4️⃣ Copiar proyecto al contenedor
COPY . /var/www/html
WORKDIR /var/www/html

# 5️⃣ Dar permisos correctos a storage y bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# 6️⃣ Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# 7️⃣ Evitar warning de Apache sobre ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 8️⃣ Exponer puerto 8080 (Railway lo mapea automáticamente)
EXPOSE 8080

# 9️⃣ Iniciar Apache en primer plano
CMD ["apache2-foreground"]
