DROP DATABASE IF EXISTS phpmyadmin;
CREATE DATABASE phpmyadmin;
GRANT ALL on phpmyadmin.* to 'www-data'@'localhost' identified by 'user';
FLUSH PRIVILEGES;
