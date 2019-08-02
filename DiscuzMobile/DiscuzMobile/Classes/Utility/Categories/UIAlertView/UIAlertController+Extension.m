//
//  UIAlertController+Extension.m
//  DiscuzMobile
//
//  Created by 张积涛 on 2018/3/28.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

+ (void)alertTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller doneText:(NSString *)doneText cancelText:(NSString *)cancelText doneHandle:(void(^)(void))doneHandle cancelHandle:(void(^)(void))cancelHandle {
    UIAlertController *alertCT = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDestructive;
    if (cancelText == nil) {
        actionStyle = UIAlertActionStyleDefault;
    } else {
    
    }
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:doneText style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        doneHandle?doneHandle():nil;
    }];
    [alertCT addAction:doneAction];
    if (cancelText != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancelHandle?cancelHandle():nil;
        }];
        [alertCT addAction:cancelAction];
    }
    [controller presentViewController:alertCT animated:YES completion:nil];
}

@end
