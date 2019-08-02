//
//  AppDelegate+XinGe.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/2/1.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (XinGe)<UNUserNotificationCenterDelegate>


/**
 配置信鸽推送只需要这个方法，放在didFinishLaunchingWithOptions里面

 @param launchOptions 进入程序的时候传入
 */
- (void)connectXinge:(NSDictionary *)launchOptions;

@end
