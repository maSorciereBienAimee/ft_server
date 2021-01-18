FROM debian:buster
RUN apt-get update && apt-get install -y \
	nginx \
	wget \
	apt-utils \
	mariadb-server \
	mariadb-client \
	openssl \
	php-fpm
COPY ./srcs/wpconfig.sql /home
COPY ./srcs/pmaconfig.sql /home
RUN etc/init.d/mysql start && mariadb < /home/wpconfig.sql
RUN etc/init.d/mysql start && mariadb < /home/pmaconfig.sql

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar -zxvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages /usr/share/phpMyAdmin

RUN wget https://fr.wordpress.org/latest-fr_FR.tar.gz \
	&& tar -zxvf latest-fr_FR.tar.gz \
	&& rm -rf latest-fr_FR.tar.gz \
	&& mv wordpress /usr/share/wordpress

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/CN=localhost"

RUN /etc/init.d/nginx start

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["nginx", "-g", "daemon off;"]
