//
//  BaseConfig.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/2/1.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

// 配置文件
#ifndef BaseConfig_h
#define BaseConfig_h

// ======================== 不同的项目在这里配置 ======================== 
#if DiscuzMobile

#define COMPANYNAME @"北京康创联盛科技有限公司" // 公司
#define APPNAME APPDISPLAYNAME
#define INCINFO [NSString stringWithFormat:@"©2001 - %@ Comsenz Inc.",NOWYEAR] // 版权时间
//#define BASEURL @"https://guanjia.comsenz-service.com/" // 域名  除了两个plugin.php的，别的都需要拼接 api/mobile/
#define BASEURL @"https://bbs.comsenz-service.com/"
#define MAINCOLOR mRGBColor(50, 120, 230) // 主题色
#define EMPTYIMAGE @"empty_icon" // 无数据显示图片
#define LOGONAME @"ap_name" // 登录、注册页APP名称图片
#define BBSRULE [NSString stringWithFormat:@"bbsrule_%@",@"discuz"]; // 网站服务条款txt名字

#elif Jinbifun // =========================

#define COMPANYNAME @"金碧坊社区"
#define APPNAME APPDISPLAYNAME
#define INCINFO [NSString stringWithFormat:@"©2008 - %@ jinbifun.com All Rights Reserved",NOWYEAR] // 版权
#define BASEURL @"http://www.jinbifun.com/"
#define MAINCOLOR mRGBColor(220, 130, 0)
#define EMPTYIMAGE @"empty_icon-Jinbifun"
#define LOGONAME @"ap_name-Jinbifun"
#define BBSRULE [NSString stringWithFormat:@"bbsrule_%@",@"jinbifun"];

#elif Penjing // =========================

#define COMPANYNAME @"武汉大素网络科技有限公司"
#define APPNAME [NSString stringWithFormat:@"中盆会%@",APPDISPLAYNAME]
#define INCINFO [NSString stringWithFormat:@"©2001 - %@ cnpenjing Inc.",NOWYEAR]
#define BASEURL @"http://bbs.cnpenjing.com/"
#define MAINCOLOR mRGBColor(50, 120, 230)
#define EMPTYIMAGE @"empty_icon"
#define LOGONAME @"ap_name-Penjing"
#define BBSRULE [NSString stringWithFormat:@"bbsrule_%@",@"penjing"];

#endif

#pragma mark - 三方 ================================================

# if Penjing
// 盆景艺术
// QQ 41eee67e
#define QQ_APPID @"1106740682"
#define QQ_APPKEY @"g5yjrzdBCx9aqTuW"
// 微信
#define WX_APPID @"wx415711c8d38a9069"
#define WX_APPSECRET @"be7602484bfed85ef180affd3d32c433"

#else

// QQ 
#define QQ_APPID @"1106175614"
#define QQ_APPKEY @"UniSayYSodrfQIqp"
// 微信
#define WX_APPID @"wxb41d0fec8fa0d1c6"
#define WX_APPSECRET @"d4005c8f16678309e7c98b2a1ee82bc0"

#endif

// 分享,三方登录：
// shareSDK
#define SHARE_APPKEY @"1d7decfd68b09"

// 微博
#define WB_APPID @"2036253932"
#define WB_APPSECRET @"137b9bd42c1c49726645b08fbf666b4f"
#define REDIRRCTURI @"http://comsenz-service.com"

// 信鸽
//#define XG_APPID 2200202535
//#define XG_APPKEY @"IR3T49RE13YU"
#define XGTOKEN @"XGTOKEN"
#define XG_APPID      2200197269
#define XG_APPKEY     @"IA291LAB26VK"
#define XG_SECRETKEY     @"ed12d32df611c3406f07c1772fcb335e"

#endif

