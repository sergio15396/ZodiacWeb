# 1️⃣ Imagen base con PHP 8.3 y Apache
FROM php:8.3-apache

# 2️⃣ Instalar dependencias necesarias y SQLite
RUN apt-get update && apt-get install -y \
    libsqlite3-dev unzip git \
    && docker-php-ext-install pdo pdo_sqlite \
    && a2enmod rewrite

# 3️⃣ Configurar DocumentRoot a /public de Laravel
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# 4️⃣ Evitar warning de Apache sobre ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# 5️⃣ Copiar proyecto al contenedor
COPY . /var/www/html
WORKDIR /var/www/html

# 6️⃣ Dar permisos correctos a storage y bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# 7️⃣ Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# 8️⃣ Definir variable de entorno para Railway
ENV PORT=8080

# 9️⃣ Exponer puerto 8080
EXPOSE 8080

# 🔟 Comando para iniciar Apache en primer plano
CMD ["apache2-foreground"]
