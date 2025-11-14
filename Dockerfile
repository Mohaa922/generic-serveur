FROM php:8.3-apache

RUN apt-get update \
 && apt-get install -y libicu-dev unzip git \
 && docker-php-ext-install intl pdo pdo_mysql \
 && rm -rf /var/lib/apt/lists/* \
 && a2enmod rewrite

# Symfony : le dossier public est la racine web
ENV APACHE_DOCUMENT_ROOT=/www/public

# 1) Changer le DocumentRoot du VirtualHost
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/000-default.conf

# 2) Autoriser /www/public dans la conf Apache
RUN printf '<Directory "/www/public">\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>\n' > /etc/apache2/conf-enabled/www-public.conf

# 3) Créer le dossier (le volume viendra par-dessus)
RUN mkdir -p /www \
 && chown -R www-data:www-data /www

WORKDIR /www
