-- INSERT UPDATE sql for 'Audio';
INSERT INTO `Audio` (`id`,`sounds_path`,`desc`) VALUES ('1001','client/audio/music_home.mp3','主城长音乐') ON DUPLICATE KEY UPDATE `id` = '1001',`sounds_path` = 'client/audio/music_home.mp3',`desc` = '主城长音乐';
INSERT INTO `Audio` (`id`,`sounds_path`,`desc`) VALUES ('1002','client/audio/default_sure.mp3','确定') ON DUPLICATE KEY UPDATE `id` = '1002',`sounds_path` = 'client/audio/default_sure.mp3',`desc` = '确定';
INSERT INTO `Audio` (`id`,`sounds_path`,`desc`) VALUES ('1003','client/audio/default_close.mp3','取消/关闭') ON DUPLICATE KEY UPDATE `id` = '1003',`sounds_path` = 'client/audio/default_close.mp3',`desc` = '取消/关闭';
