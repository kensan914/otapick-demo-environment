CREATE DATABASE IF NOT EXISTS otapick CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'otapick'@'%' IDENTIFIED BY 'gin-TK46';
GRANT ALL PRIVILEGES ON otapick.* TO 'otapick'@'%';

FLUSH PRIVILEGES;
