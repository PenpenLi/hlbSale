-- INSERT UPDATE sql for 'error_code';
INSERT INTO `error_code` (`id`,`zhcn`,`zhtw`,`en`,`desc`) VALUES ('1000','活动尚未开始','活動尚未開始','','') ON DUPLICATE KEY UPDATE `id` = '1000',`zhcn` = '活动尚未开始',`zhtw` = '活動尚未開始',`en` = '',`desc` = '';
INSERT INTO `error_code` (`id`,`zhcn`,`zhtw`,`en`,`desc`) VALUES ('1001','元宝不足','元寶不足','','') ON DUPLICATE KEY UPDATE `id` = '1001',`zhcn` = '元宝不足',`zhtw` = '元寶不足',`en` = '',`desc` = '';
INSERT INTO `error_code` (`id`,`zhcn`,`zhtw`,`en`,`desc`) VALUES ('1002','网络不稳定','網絡不穩定','','') ON DUPLICATE KEY UPDATE `id` = '1002',`zhcn` = '网络不稳定',`zhtw` = '網絡不穩定',`en` = '',`desc` = '';
