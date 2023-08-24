SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';

REVOKE ALL ON *.* FROM dbuser;

DROP DATABASE IF EXISTS `flag`;
CREATE DATABASE IF NOT EXISTS `flag` CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

USE `flag`;

DROP TABLE IF EXISTS `flag`;
CREATE TABLE `flag` (
    `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `flag` varchar(128) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `flag` (`flag`) VALUES ('FLAG{this_is_the_first_flag}');
INSERT INTO `flag` (`flag`) VALUES ('FLAG{BzFhLm7vsNqMphieXg5FfXCpvUUCL3}');
INSERT INTO `flag` (`flag`) VALUES ('FLAG{N6i7W2NXdX3Tqf7Hd8YeQnkiWqxYjG}');
INSERT INTO `flag` (`flag`) VALUES ('FLAG{y6H9KuW9vD9hpDTkrKj9xZ8h43xJMb}');
INSERT INTO `flag` (`flag`) VALUES ('FLAG{PUPzRRnstZt8EvTozKTePW229xKyMX}');

DROP TABLE IF EXISTS `submit`;
CREATE TABLE `submit` (
    `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `user` varchar(128) not null,
    `flag` varchar(128) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

REVOKE ALL ON flag.* FROM dbuser;
GRANT INSERT ON flag.* TO dbuser;
GRANT SELECT ON flag.* TO dbuser;

FLUSH PRIVILEGES;
