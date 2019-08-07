//
//  CheckHelper.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/12.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "CheckHelper.h"

@implementation CheckHelper

+ (instancetype)shareInstance {
    static CheckHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CheckHelper alloc] init];
    });
    return helper;
}

- (void)checkRequest {
    [self checkRequestSuccess:nil failure:nil];
}

- (void)checkRegisterRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    [self checkRequestSuccess:^{
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            request.urlString = self.regUrl;
        } success:^(id responseObject, JTLoadType type) {
            if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]] &&  [[responseObject objectForKey:@"Variables"] objectForKey:@"reginput"]) {
                self.regKeyDic = [NSDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"reginput"]];
            }
            success?success():nil;
        } failed:^(NSError *error) {
            failure?failure():nil;
        }];
    } failure:failure];
}

- (void)checkRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_Check;
    } success:^(id responseObject, JTLoadType type) {
        if ([DataCheck isValidString:[responseObject objectForKey:@"regname"]]) {
            NSString *regUrl = [NSString stringWithFormat:@"%@&mod=%@",url_Register,[responseObject objectForKey:@"regname"]];
            if ([DataCheck isValidString:[responseObject objectForKey:@"formhash"]]) {
                [Environment sharedEnvironment].formhash = [responseObject objectForKey:@"formhash"];
            }
            self.regUrl = regUrl;
        }
        success?success():nil;
    } failed:^(NSError *error) {
        failure?failure():nil;
    }];
}

@end
