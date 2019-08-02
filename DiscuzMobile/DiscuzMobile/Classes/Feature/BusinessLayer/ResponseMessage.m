//
//  ResponseMessage.m
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/3/19.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "ResponseMessage.h"

@implementation ResponseMessage

+ (BOOL)autherityJudgeResponseObject:(NSDictionary *)responseObject refuseBlock:(void(^)(NSString *message))refuseBlock {
    NSString *messageval = [[responseObject objectForKey:@"Message"] objectForKey:@"messageval"];
    if ([messageval containsString:@"nonexistence"] || [messageval containsString:@"nopermission"] || [messageval containsString:@"nomedal"]) {
        refuseBlock?refuseBlock([[[responseObject objectForKey:@"Message"]  objectForKey:@"messagestr"] transformationStr]):nil;
        return NO;
    }
    return YES;
}

@end
