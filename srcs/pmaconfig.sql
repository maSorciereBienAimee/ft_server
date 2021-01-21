CREATE USER 'user'@'localhost' IDENTIFIED BY 'user';
GRANT ALL on phpmyadmin.* to 'user'@'localhost' IDENTIFIED BY 'user';
FLUSH PRIVILEGES;
