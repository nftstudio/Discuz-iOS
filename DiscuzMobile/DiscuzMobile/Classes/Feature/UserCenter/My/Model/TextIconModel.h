//
//  TextIconModel.h
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextIconModel : NSObject

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *detail;

- (instancetype)initWithText:(NSString *)text andIconName:(NSString *)iconName andDetail:(NSString *)detail;
+ (instancetype)initWithText:(NSString *)text andIconName:(NSString *)iconName andDetail:(NSString *)detail;

@end
