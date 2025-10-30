# --- Firefly III on Railway (PHP 8.4) ---
FROM php:8.4-apache

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libpq-dev libicu-dev g++ \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd mbstring xml zip opcache intl bcmath

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy project and install composer deps
WORKDIR /var/www/html
COPY . .
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose and run
EXPOSE 80
CMD ["apache2-foreground"]
