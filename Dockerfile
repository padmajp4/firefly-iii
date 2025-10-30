# --- Firefly III in Docker (for Railway) ---
FROM php:8.3-apache

# Install system dependencies + PHP extensions
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd mbstring xml zip opcache

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy app and install composer deps
WORKDIR /var/www/html
COPY . .
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose and start Apache
EXPOSE 80
CMD ["apache2-foreground"]
