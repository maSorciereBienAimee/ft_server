FROM debian:buster
ENV INDEX="on"
RUN apt-get update && apt-get install -y \
	nginx \
	wget \
	apt-utils \
	mariadb-server \
	mariadb-client \
	openssl \
	php-fpm php-json php-mbstring php-mysql \
	php-cli php-gd php-bcmath php-xml php-zip php-apcu php-curl

COPY ./srcs/wpconfig.sql /home
COPY ./srcs/pmaconfig.sql /home
COPY ./srcs/set_phpmyadmin.php /home
COPY ./srcs/set_wordpress.php /home
COPY ./srcs/nginx_conf_on /home
COPY ./srcs/nginx_conf_off /home
COPY ./srcs/init.sh /home

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/CN=localhost"
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir var/www/localhost
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar -zxvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages /var/www/localhost/phpmyadmin
RUN cp -pr /home/set_phpmyadmin.php /var/www/localhost/phpmyadmin/config.inc.php
RUN etc/init.d/mysql start && mariadb -u root < /var/www/localhost/phpmyadmin/sql/create_tables.sql
RUN etc/init.d/mysql start && mariadb -u root < /home/pmaconfig.sql
RUN wget https://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -zxvf latest-fr_FR.tar.gz \
	&& rm -rf latest-fr_FR.tar.gz \
	&& mv wordpress /var/www/localhost/wordpress
RUN etc/init.d/mysql start && mariadb -u root < /home/wpconfig.sql
RUN mv /home/set_wordpress.php /var/www/localhost/wordpress/wp-config.php
RUN chmod 755 /var/www/*
RUN chown -R www-data:www-data /var/www/*

EXPOSE 443 80

ENTRYPOINT ["/home/init.sh"]
#CMD ["true", "batman", "superman"]
