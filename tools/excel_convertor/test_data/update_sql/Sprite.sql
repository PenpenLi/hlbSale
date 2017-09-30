-- INSERT UPDATE sql for 'Sprite';
INSERT INTO `Sprite` (`id`,`path`,`desc1`) VALUES ('1001','client/activity/activity_1001.png','旗子') ON DUPLICATE KEY UPDATE `id` = '1001',`path` = 'client/activity/activity_1001.png',`desc1` = '旗子';
