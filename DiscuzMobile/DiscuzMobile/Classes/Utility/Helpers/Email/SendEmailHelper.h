//
//  SendEmailHelper.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/4/8.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendEmailHelper : NSObject

@property (nonatomic, weak) UINavigationController *navigationController;
+ (instancetype)shareInstance;
- (void)prepareSendEmail;
@end
