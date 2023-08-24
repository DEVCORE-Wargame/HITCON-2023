SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';

REVOKE ALL ON *.* FROM dbuser;

DROP DATABASE IF EXISTS `ipdb`;
CREATE DATABASE IF NOT EXISTS `ipdb` CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
USE `ipdb`;
DROP TABLE IF EXISTS `iplog`;
CREATE TABLE `iplog` (
    `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `ip` varchar(128) not null,
    `country` varchar(16) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP DATABASE IF EXISTS `flag_vBu6eL`;
CREATE DATABASE IF NOT EXISTS `flag_vBu6eL` CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
USE `flag_vBu6eL`;
DROP TABLE IF EXISTS `flag_hH33YT`;
CREATE TABLE `flag_hH33YT` (
    `id` INTEGER PRIMARY KEY AUTO_INCREMENT,
    `flag_jQM2hM` varchar(128) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `flag_hH33YT` (`flag_jQM2hM`) VALUES ('DEVCORE{01d_sch00l_1s_sti11_g00d}');

REVOKE ALL ON ipdb.* FROM dbuser;
GRANT INSERT ON ipdb.iplog TO dbuser;
GRANT SELECT ON ipdb.iplog TO dbuser;
GRANT SELECT ON `flag_vBu6eL`.* TO dbuser;

FLUSH PRIVILEGES;

