--
-- Table structure for table `Audio`
--
DROP TABLE IF EXISTS `Audio`;
CREATE TABLE IF NOT EXISTS `Audio` (
`id` int(11) NOT NULL  COMMENT '作者:
千位1=魏国，2=蜀国，3=吴国，4=群雄',
`sounds_path` varchar(512) ,
`desc` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;
