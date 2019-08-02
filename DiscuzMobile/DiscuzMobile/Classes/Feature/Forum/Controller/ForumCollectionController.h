//
//  ForumCollectionController.h
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ForumType) {
    Forum_index = 0,
    Forum_hot,
};

@interface ForumCollectionController : BaseViewController

@property (nonatomic, assign) ForumType type;

@end
