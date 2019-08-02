//
//  AppDelegate+Local.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/2/1.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate (Local)<CLLocationManagerDelegate>

- (void)useLocal;
@end
