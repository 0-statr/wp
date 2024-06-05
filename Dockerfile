# Use the official WordPress image from the Docker Hub
FROM wordpress:latest

# Install required packages for debugging
RUN apt-get update && apt-get install -y curl && apt-get install -y git

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Set up error handling
RUN set -e

# Download and extract PostgreSQL plugin for WordPress
RUN git clone https://github.com/kevinoid/postgresql-for-wordpress.git && \
    echo "Download successful" && \
    mv postgresql-for-wordpress/pg4wp /var/www/html/wp-content/plugins/pg4wp && \
    cp -rf /var/www/html/wp-content/plugins/pg4wp/db.php /var/www/html/wp-content/db.php  && \
    #cp -rf /var/www/html/wp-content/wp-config-sample.php  /var/www/html/wp-content/wp-config.php  &&\
    echo "Move successful"

RUN chown -R www-data:www-data /var/www/html/wp-content
RUN chmod -R 777  /var/www/html/wp-content

RUN rm -rf /usr/local/etc/php/conf.d/uploads.ini
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini
  
#ENV WORDPRESS_DB_HOST=dpg-cpe5ipn109ks73eq12h0-a.oregon-postgres.render.com
#ENV WORDPRESS_DB_USER=tamilloggers
#ENV WORDPRESS_DB_PASSWORD=wH5HZ627ED1lLpJL5XunItNFJo0t1xJN
#ENV WORDPRESS_DB_NAME=tamilloggers

EXPOSE 80

CMD ["apache2-foreground"]
