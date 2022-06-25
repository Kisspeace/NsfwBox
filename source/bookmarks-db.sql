--DROP TABLE IF EXISTS `items`;
--DROP TABLE IF EXISTS `groups`;
--DROP VIEW IF EXISTS `only_content`;
--DROP VIEW IF EXISTS `only_requests`;

-- bookmark groups
CREATE TABLE `groups` (
	`id`        INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`      VARCHAR(255),
	`timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`about`     TEXT
);

-- All bookmark items
CREATE TABLE `items` (
	`origin`    INTEGER,
	`type`      INTEGER,
	`about`     TEXT,
	`timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`object`    JSON,
	`group_id`  INTEGER DEFAULT 1,
	FOREIGN KEY(group_id) REFERENCES `groups` (id)
);

-- bookmarks with content only
CREATE VIEW `only_content` AS
	SELECT * FROM `items` WHERE (`type` = 0);

-- bookmarks with search requests only
CREATE VIEW `only_requests` AS
	SELECT * FROM `items` WHERE (`type` = 1);


