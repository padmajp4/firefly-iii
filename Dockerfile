# --- Firefly III on Railway (stable build) ---
FROM php:8.4-apache

# Install dependencies + PHP extensions
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev libpq-dev libicu-dev g++ \
    && docker-php-ext-install pdo pdo_pgsql pgsql gd mbstring xml zip opcache intl bcmath

# Enable Apache rewrite
RUN a2enmod rewrite

# Copy app files
WORKDIR /var/www/html
COPY . .
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install dependencies but skip post-install scripts
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs --no-scripts

# Fix permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port and start Apache
EXPOSE 80
CMD ["apache2-foreground"]
