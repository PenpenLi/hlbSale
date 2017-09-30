--
-- Table structure for table `Activity`
--
DROP TABLE IF EXISTS `Activity`;
CREATE TABLE IF NOT EXISTS `Activity` (
`id` int(11) NOT NULL ,
`activity_name` int(11) COMMENT '作者:
最多7个字',
`name_dec` varchar(512) ,
`activity_desc` int(11) COMMENT '作者:
最多7个字',
`desc` varchar(512) ,
`date_type` int(11) COMMENT '作者:
1、永久性活动
2、时效性
3、开服性',
`open_date` int(11) ,
`close_date` int(11) ,
`show_open_date` int(11) COMMENT '作者:
活动重新开启间隔时间
天
1002限时比赛活动=隔X天后重新开启
1004充值礼包活动=隔X天后重新抽取',
`show_close_date` int(11) ,
`active_same` int(11) ,
`type_icon` int(11) ,
`drop` text ,
`interval` int(11) ,
`show_order` int(11) COMMENT '作者:
列表显示顺序',
`banner_show` int(11) ,
`path_type` int(11) COMMENT '作者:
运营活动入口区分',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Growth_Number_reward`
--
DROP TABLE IF EXISTS `Growth_Number_reward`;
CREATE TABLE IF NOT EXISTS `Growth_Number_reward` (
`id` int(11) NOT NULL  COMMENT '购买人数-奖励表

',
`number` int(11) COMMENT '总计购买人数',
`drop` int(11) COMMENT '奖励dropid',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Growth_Level_reward`
--
DROP TABLE IF EXISTS `Growth_Level_reward`;
CREATE TABLE IF NOT EXISTS `Growth_Level_reward` (
`id` int(11) NOT NULL  COMMENT '府衙等级-奖励表

',
`level` int(11) COMMENT '府衙等级',
`drop` int(11) COMMENT '奖励dropid',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Drop`
--
DROP TABLE IF EXISTS `Drop`;
CREATE TABLE IF NOT EXISTS `Drop` (
`id` int(11) NOT NULL  COMMENT '陈涛:
通用掉落
1~99999999
开头不同对应系统不同',
`drop_type` int(11) COMMENT '陈涛:
掉落类型
1-整组奖励中部分掉落，掉落数量根据drop_count值
2-整组奖励全部掉落
3-VIP激活
4-抽卡神武将信物掉落（去除玩家已有的神武将后再执行n抽1）
5-神武将经验道具，掉落神武将经验',
`min_level` int(11) COMMENT '府衙最低等级
drop_type=3时，表示VIP等级',
`max_level` int(11) COMMENT '府衙最高等级
drop_type=3时，表示VIP等级',
`rate` int(11) COMMENT '陈涛:
掉落概率（万分比）',
`drop_count` int(11) COMMENT '掉落数量',
`drop_data` text COMMENT '陈涛:
掉落
掉落类型;掉落ID;掉落数量;概率',
`desc1` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Astrology`
--
DROP TABLE IF EXISTS `Astrology`;
CREATE TABLE IF NOT EXISTS `Astrology` (
`id` int(11) NOT NULL ,
`type` int(11) COMMENT '徐力丰:
1 占星
2 天陨',
`drop_group` int(11) COMMENT '徐力丰:
掉落序号',
`drop_id` int(11) COMMENT '徐力丰:
drop id',
`min_count` int(11) COMMENT '徐力丰:
累计未抽到该drop的最小次数',
`max_count` int(11) COMMENT '徐力丰:
累计未抽到该drop的最大次数',
`chance` int(11) COMMENT '徐力丰:
万分比',
`Special_next_drop_group` int(11) COMMENT '徐力丰:
特殊的掉落组
优先执行
仅执行一次',
`next_drop_group` int(11) COMMENT '徐力丰:
若无掉落，则跳转下一个掉落包',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Gamble_general_soul`
--
DROP TABLE IF EXISTS `Gamble_general_soul`;
CREATE TABLE IF NOT EXISTS `Gamble_general_soul` (
`id` int(11) NOT NULL  COMMENT '陆阳:
1=魏
2=蜀
3=吴
4=群',
`drop_id` int(11) COMMENT '陆阳:
cost_id 
10022 将魂首次半价
10023 将魂全价
10024 将魂10连',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Equipment`
--
DROP TABLE IF EXISTS `Equipment`;
CREATE TABLE IF NOT EXISTS `Equipment` (
`id` int(11) NOT NULL  COMMENT '作者:
1-武将武器
2-武将防具
3-武将饰品
',
`priority` int(11) COMMENT '作者:
优先级',
`item_original_id` int(11) ,
`equip_name` int(11) COMMENT '作者:
装备名字
60-武器
62-防具
64-饰品
66-主公宝物',
`desc1` varchar(512) ,
`description` int(11) COMMENT '作者:
装备介绍
61-武器
62-防御
63-饰品
64-主公',
`desc2` varchar(512) ,
`equip_type` int(11) COMMENT '作者:
道具ID
0-万能装备（不可携带）
1-武器（仅武将携带）
2-防具（仅武将携带）
3-饰品（仅武将携带）
4-坐骑',
`star_level` int(11) COMMENT '作者:
装备星级
0-初始装备
1-1星装备
2-2星装备
3-3星装备
4-4星装备
5-5星装备',
`max_star_level` int(11) ,
`quality_id` int(11) COMMENT '作者:
道具品质
1-白色
2-绿色
3-蓝色
4-紫色
5-橙色',
`force` int(11) COMMENT '作者:
武力',
`intelligence` int(11) COMMENT '作者:
智力',
`governing` int(11) COMMENT '作者:
统治力',
`charm` int(11) COMMENT '作者:
魅力',
`political` int(11) COMMENT '作者:
政治',
`min_general_level` int(11) COMMENT '作者:
武将穿戴等级',
`equip_skill_id` text COMMENT '作者:
装备技能ID
可能含有多个技能',
`equip_icon` int(11) ,
`recast` int(11) COMMENT '重铸
对应drop_id',
`recast_cost` int(11) COMMENT '作者:
重铸消耗，元宝',
`decomposition` int(11) COMMENT '分解，获得白银数量
对应drop_id',
`consume` text COMMENT '作者:
所需材料
1-材料
2-装备
3-白银

道具类型，道具ID，数量
901-白品质装备
902-绿品质装备
903-蓝品质装备
904-紫品质装备
905-橙品质装备

',
`target_equip` int(11) COMMENT '作者:
目标装备ID',
`power` int(11) COMMENT '作者:
装备战力',
`get_path` text COMMENT '作者:
快速获得途径
1=世界地图打怪
2=合成
3=跳转磨坊（还没制作）
4=商城
5=铁匠铺分解
6=重铸
7=集市
',
`target_unlock` int(11) COMMENT '作者:
进阶目标该版本是否解锁
1 解锁
0 未解锁',
`combat_skill_id` int(11) ,
`battle_skill_id` int(11) ,
`skill_level` int(11) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Equip_master`
--
DROP TABLE IF EXISTS `Equip_master`;
CREATE TABLE IF NOT EXISTS `Equip_master` (
`id` int(11) NOT NULL  COMMENT '作者:
主公的宝物从4开头',
`priority` int(11) COMMENT '作者:
优先级',
`item_original_id` int(11) ,
`equip_name` int(11) COMMENT '作者:
主公宝物名字
61-武器
62-防御
63-饰品
64-主公',
`desc1` varchar(512) ,
`description` int(11) COMMENT '作者:
主公宝物介绍
61-武器
62-防御
63-饰品
64-主公',
`desc2` varchar(512) ,
`quality_id` int(11) COMMENT '作者:
道具品质
1-白色
2-绿色
3-蓝色
4-紫色
5-橙色',
`min_master_level` int(11) COMMENT '作者:
主公穿戴等级',
`equip_skill_id` text COMMENT '作者:
装备技能ID
可能含有多个技能',
`power` int(11) COMMENT '作者:
装备战力',
`equip_icon` int(11) COMMENT '作者:
宝物ICON',
`type` int(11) COMMENT '作者:
内政1
战争2',
`selldrop` int(11) COMMENT '作者:
该宝物出售获得的锦囊数量',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Equip_skill`
--
DROP TABLE IF EXISTS `Equip_skill`;
CREATE TABLE IF NOT EXISTS `Equip_skill` (
`id` int(11) NOT NULL  COMMENT '作者:
6位数
2-武将武器
3-武将防具
4-武将饰品
5-主公宝物',
`skill_buff_id` text ,
`skill_description` int(11) ,
`desc1` varchar(512) ,
`num` int(11) COMMENT '作者:
道具初始值
根据buff不同，值不同，如果是百分比，则用万分比，这里只写数字',
`min` int(11) COMMENT '作者:
最小值（万分比）',
`max` int(11) COMMENT '作者:
最大值（万分比）',
`equip_arm_type` int(11) COMMENT '作者:
用于选择出征部队武将带兵特性标示
1步兵
2骑兵
3弓兵
4车兵',
`equip_arm_description` int(11) ,
`desc2` varchar(512) ,
`equipment_active_on_build` text COMMENT '驻守时，装备buff生效的建筑origin_id',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `error_code`
--
DROP TABLE IF EXISTS `error_code`;
CREATE TABLE IF NOT EXISTS `error_code` (
`id` int(11) NOT NULL ,
`zhcn` varchar(512) ,
`zhtw` varchar(512) ,
`en` varchar(512) ,
`desc` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Item`
--
DROP TABLE IF EXISTS `Item`;
CREATE TABLE IF NOT EXISTS `Item` (
`id` int(11) NOT NULL ,
`priority` int(11) COMMENT '陈涛:
优先级，数字越大优先级低',
`item_original_id` int(11) COMMENT '陈涛:
原始道具对应ID',
`item_name` int(11) ,
`desc1` varchar(512) ,
`item_num_show` int(11) COMMENT '是否显示资源数量
1显示
显示规则:
<1000 直接显示
1000～999999：显示n.nK精确到小数点后1位
1000000+：显示n.nnM精确到小数点后2位',
`item_type` int(11) COMMENT '陈涛:
道具类型
1-资源道具（粮食、黄金、木头、铁材、石材）
2-消耗道具(会出现在包裹中）
3-材料道具
4-武将信物
5-神武将将魂
6-红色装备碎片',
`item_show_type` int(11) COMMENT '陆阳:
区分道具打开类型
1、打开宝箱类界面
2、打开经验道具
3、使用BUFF类道具
4、激活VIP
',
`item_use_num` int(11) COMMENT '陆阳:
道具默认选中数量
0=无限大
1=只选择1个',
`item_level_id` int(11) COMMENT '陈涛:
道具等级
1-白
2-绿
3-蓝
4-紫
5-橙',
`item_introduction` int(11) COMMENT '陈涛:
道具介绍',
`desc2` varchar(512) ,
`res_icon` int(11) COMMENT '陈涛:
图片ICON
',
`rank` int(11) ,
`cash_in` text COMMENT '陈涛:
购入
1-黄金
2-粮食
3-木材
4-石材
5-铁材
6-gem',
`cash_out` int(11) COMMENT '陈涛:
卖出价格',
`button_type` int(11) COMMENT '陈涛:
物品能否使用
0-不可使用，弹出说明框
1-使用（后面比有drop或者use）
2-合成',
`drop` text COMMENT '使用可获得
对应drop表
如果为空则表示使用之后不会获得物品
逗号分隔：从指定的一组drop中取一个掉落
分号分隔：设定多组drop
注意：每组drop必须有掉落不然会报错',
`item_acceleration` int(11) COMMENT '陈涛:
加速道具使用后效果
对应Accelerate表
如果为空则表示非加速道具',
`buff_type` int(11) COMMENT '陈涛:
对应buff表的id',
`duration` int(11) COMMENT '陈涛:
持续时间/秒',
`use_level` int(11) ,
`direct_price` int(11) COMMENT '徐力丰:
张董琪使用 加速直接购买价格',
`get_path` text COMMENT '作者:
快速获得途径
1=世界地图打怪
2=合成
3=跳转磨坊
4=商城
5=铁匠铺分解
6=重铸
7=集市
8=占星（低级抽奖）
9=天陨（高级抽奖）
10=融合（神盔甲合成）
11=对酒
12=功勋商店
101=联盟商店
102=活动
103=锦囊商店
104=商店-战争标签
13=祭天
14=神盔甲分解',
`decomposition` int(11) COMMENT '徐力丰:
分解掉落
该字段用于御龙盔甲分解',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Item_Combine`
--
DROP TABLE IF EXISTS `Item_Combine`;
CREATE TABLE IF NOT EXISTS `Item_Combine` (
`id` int(11) NOT NULL  COMMENT '目标道具ID',
`consume` text COMMENT '作者:
所需材料',
`target_equip` int(11) COMMENT '作者:
目标装备ID',
`count` int(11) COMMENT '作者:
数量',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Use`
--
DROP TABLE IF EXISTS `Use`;
CREATE TABLE IF NOT EXISTS `Use` (
`id` int(11) NOT NULL ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `item_acceleration`
--
DROP TABLE IF EXISTS `item_acceleration`;
CREATE TABLE IF NOT EXISTS `item_acceleration` (
`id` int(11) NOT NULL ,
`desc1` varchar(512) ,
`type` int(11) COMMENT '陈涛:
0-通用道具
1-建筑加速
2-造兵加速
3-医疗加速
4-研究加速
5-早陷阱加速',
`item_num` int(11) COMMENT '陈涛:
时间：秒
',
`desc2` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `zhcn`
--
DROP TABLE IF EXISTS `zhcn`;
CREATE TABLE IF NOT EXISTS `zhcn` (
`id` int(11) NOT NULL ,
`desc` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `zhtw`
--
DROP TABLE IF EXISTS `zhtw`;
CREATE TABLE IF NOT EXISTS `zhtw` (
`id` int(11) NOT NULL ,
`desc` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Pricing`
--
DROP TABLE IF EXISTS `Pricing`;
CREATE TABLE IF NOT EXISTS `Pricing` (
`id` int(11) NOT NULL ,
`channel` varchar(512) COMMENT '作者:
充值渠道',
`desc` int(11) ,
`desc1` varchar(512) ,
`type` varchar(512) COMMENT '作者:
货币种类',
`price` varchar(512) COMMENT '作者:
现金价格',
`goods_type` int(11) COMMENT '作者:
充值类型
1、元宝
2、永久月卡
3、月卡
4、充值礼包',
`count` int(11) COMMENT '作者:
充值获得元宝数',
`first_add_count` int(11) COMMENT '作者:
首次充值额外获得',
`add_count` int(11) COMMENT '作者:
每次充值额外获得',
`add_percent` int(11) COMMENT '作者:
客户端优惠比例 万分比
对礼包即性价比
1000表示额外优惠10%',
`isopen` int(11) COMMENT '作者:
是否打开此充值项
1-常态开启
2-特定时间段开启',
`isshow` int(11) ,
`bonus_drop` int(11) COMMENT '作者:
额外奖励',
`payment_code` varchar(512) ,
`gift_type` int(11) COMMENT '作者:
礼包类别，用于activity_Commodity表中对应礼包类别',
`product_id` int(11) COMMENT '作者:
渠道需要后台对应商品编码
相关渠道：
联想',
`icon` int(11) ,
`rmb_value` int(11) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Pay_way`
--
DROP TABLE IF EXISTS `Pay_way`;
CREATE TABLE IF NOT EXISTS `Pay_way` (
`id` int(11) NOT NULL ,
`channel` varchar(512) COMMENT '作者:
渠道客户端',
`pay_way` varchar(512) COMMENT '作者:
可用的支付方式',
`pay_way_lv` text COMMENT '作者:
每个充值项对应的开启等级',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Android_Channel`
--
DROP TABLE IF EXISTS `Android_Channel`;
CREATE TABLE IF NOT EXISTS `Android_Channel` (
`id` int(11) NOT NULL ,
`channel_id` varchar(512) ,
`channel_name` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Sprite`
--
DROP TABLE IF EXISTS `Sprite`;
CREATE TABLE IF NOT EXISTS `Sprite` (
`id` int(11) NOT NULL ,
`path` varchar(512) ,
`desc1` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

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

--
-- Table structure for table `GeneralAnims`
--
DROP TABLE IF EXISTS `GeneralAnims`;
CREATE TABLE IF NOT EXISTS `GeneralAnims` (
`id` int(11) NOT NULL ,
`path_1` varchar(512) COMMENT '作者:
正面武将',
`path_2` varchar(512) COMMENT '作者:
正面武将',
`desc1` varchar(512) ,
`desc2` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `SkillAnims`
--
DROP TABLE IF EXISTS `SkillAnims`;
CREATE TABLE IF NOT EXISTS `SkillAnims` (
`id` int(11) NOT NULL ,
`path` varchar(512) COMMENT '作者:
技能特效位置',
`play_type` int(11) COMMENT '作者:
播放模式：
1：在启动位置播放
2：在目标位置播放
3：全屏中央播放
4：飞行特效（飞行特效循环播放',
`anims_type` int(11) COMMENT '作者:
动画类型
1：不切面，2：切面',
`desc` varchar(512) COMMENT '作者:
类型
1=普攻
2=技能
3=BUFF',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `BuffAnims`
--
DROP TABLE IF EXISTS `BuffAnims`;
CREATE TABLE IF NOT EXISTS `BuffAnims` (
`id` int(11) NOT NULL ,
`path` varchar(512) COMMENT '作者:
技能特效位置',
`desc` varchar(512) COMMENT '作者:
类型
1=普攻
2=技能
3=BUFF',
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `ParticleAnims`
--
DROP TABLE IF EXISTS `ParticleAnims`;
CREATE TABLE IF NOT EXISTS `ParticleAnims` (
`id` int(11) NOT NULL ,
`folder` varchar(512) ,
`name` varchar(512) ,
`offsetx` int(11) ,
`offsety` int(11) ,
`duration` int(11) COMMENT '作者:
时间
',
`isloop` int(11) COMMENT '作者:
0 不循环
1 循环',
`desc1` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Plist`
--
DROP TABLE IF EXISTS `Plist`;
CREATE TABLE IF NOT EXISTS `Plist` (
`id` int(11) NOT NULL ,
`path` varchar(512) ,
`desc1` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Frames`
--
DROP TABLE IF EXISTS `Frames`;
CREATE TABLE IF NOT EXISTS `Frames` (
`id` int(11) NOT NULL  COMMENT '作者:
千位1=魏国，2=蜀国，3=吴国，4=群雄',
`plist` int(11) ,
`playstates` varchar(512) ,
`desc1` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

--
-- Table structure for table `Starting`
--
DROP TABLE IF EXISTS `Starting`;
CREATE TABLE IF NOT EXISTS `Starting` (
`id` int(11) NOT NULL ,
`name` varchar(512) ,
`data` varchar(512) ,
PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ;

