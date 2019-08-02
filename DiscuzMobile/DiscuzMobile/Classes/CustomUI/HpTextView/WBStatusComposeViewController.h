//
//  WBStatusComposeViewController.h
//  YYKitExample
//
//  Created by ibireme on 15/9/8.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

typedef NS_ENUM(NSUInteger, WBStatusComposeViewType) {
    WBStatusComposeViewTypeStatus,  ///< 发微博
    WBStatusComposeViewTypeRetweet, ///< 转发微博
    WBStatusComposeViewTypeComment, ///< 发评论
};

/// 发布微博
@interface WBStatusComposeViewController : UIViewController
@property (nonatomic, assign) WBStatusComposeViewType type;
@property (nonatomic, copy) void (^dismiss)(NSString *comment);
@property (nonatomic, copy) void (^sendPost)(NSString *comment);

@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, assign) BOOL isShow;

@end
