# ---- Base PHP image ----
FROM php:8.3-apache

# Install system packages + PHP extensions Firefly III needs
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev sqlite3 \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite gd mbstring xml zip opcache

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy app
COPY . /var/www/html
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Permissions for storage/logs
RUN chown -R www-data:www-data storage bootstrap/cache

# Set up environment
ENV APP_ENV=production
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/data/database/database.sqlite
ENV APP_DEBUG=false
ENV QUEUE_CONNECTION=sync
ENV SESSION_DRIVER=file
ENV CACHE_DRIVER=file

# Expose port and start Apache
EXPOSE 80
CMD ["apache2-foreground"]
