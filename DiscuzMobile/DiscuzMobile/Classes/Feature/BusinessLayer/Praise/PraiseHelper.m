//
//  PraiseHelper.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/21.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "PraiseHelper.h"
#import "LoginModule.h"
#import "ThreadListModel.h"

@implementation PraiseHelper

+ (void)praiseRequestTid:(NSString *)tid successBlock:(void(^)(void))success failureBlock:(void(^)(NSError *error))failure {
    if ([LoginModule isLogged]) {
        NSDictionary * paramter=@{@"tid":tid,
                                  @"hash":[Environment sharedEnvironment].formhash
                                  };
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            request.urlString = url_Praise;
            request.parameters = paramter;
        } success:^(id responseObject, JTLoadType type) {
            DLog(@"%@",responseObject);
            if ([DataCheck isValidString:[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"]]) {
                
                NSString *message = [[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"] componentsSeparatedByString:@"_"].lastObject;
                
                if ([message isEqualToString:@"succeed"] || [message isEqualToString:@"success"]) {
                    success?success():nil;
                } else {
                    failure?failure(nil):nil;
                    [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
                }
            } else {
                failure?failure(nil):nil;
                [MBProgressHUD showInfo:@"点赞失败"];
            }
            
        } failed:^(NSError *error) {
            failure?failure(error):nil;
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:nil];
    }
}

@end
