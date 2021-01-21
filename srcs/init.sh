#!/bin/bash 

if [ "${INDEX}" = "off" ]
then
	mv /home/nginx_conf_off /etc/nginx/sites-available/localhost
elif [ "${INDEX}" = "on" ]
then
	mv /home/nginx_conf_on /etc/nginx/sites-available/localhost
else
	echo "valeur de l'index incorrecte"
fi

/etc/init.d/php7.3-fpm start
/etc/init.d/nginx start
/etc/init.d/mysql start

i=1
while [ "$i" -ne 0 ]
do
  sleep 10
done

