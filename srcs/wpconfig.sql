DROP DATABASE IF EXISTS wordpress;
CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* TO 'user'@'localhost' IDENTIFIED BY 'user';
FLUSH PRIVILEGES;
