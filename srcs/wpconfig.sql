DROP DATABASE IF EXISTS wordpress;
CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* TO 'www-data'@'localhost' IDENTIFIED BY 'user';
FLUSH PRIVILEGES;
