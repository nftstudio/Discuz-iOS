//
//  UIImageView+FindHairline.h
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/3/16.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FindHairline)
// 查找UINavigationBar分割线
+ (UIImageView*)findHairlineImageViewUnder:(UIView*)view;
@end
