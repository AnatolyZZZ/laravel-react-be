FROM php:8.3-cli

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html

ENTRYPOINT ["sh", "-c", "chown -R www-data:www-data storage bootstrap/cache && chmod -R 775 storage bootstrap/cache && php artisan migrate --force && php artisan db:seed --force && tail -f /dev/null"]
