//
//  ResponseMessage.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/3/19.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseMessage : NSObject

+ (BOOL)autherityJudgeResponseObject:(NSDictionary *)responseObject refuseBlock:(void(^)(NSString *message))refuseBlock;

@end
