//
//  JudgeImageModel.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/4/8.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const boolNoImage;

@interface JudgeImageModel : NSObject
/**
 无图模式
 @return yes 无图模式  no 有图
 */
+ (BOOL)graphFreeModel;
@end
