//
//  BoundManageController.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/12.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^RefreshBlock)(void);

@interface BoundManageController : BaseTableViewController

@property (nonatomic, strong) NSMutableDictionary *myInfoDic;
@property (nonatomic, copy) RefreshBlock refreshBlock;

@end
