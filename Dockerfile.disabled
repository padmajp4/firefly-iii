# Firefly III on Railway — Simplified Stable Dockerfile
FROM php:8.3-apache

# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libpq-dev libicu-dev g++ \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd mbstring xml zip opcache intl bcmath

# Enable Apache rewrite for Laravel
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application source
COPY . .

# Install Composer (from Composer official image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP dependencies (skip scripts for safety)
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --no-scripts

# Fix storage permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Set Apache DocumentRoot to /var/www/html/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
