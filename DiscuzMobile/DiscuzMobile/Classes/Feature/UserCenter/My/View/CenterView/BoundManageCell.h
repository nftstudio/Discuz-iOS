//
//  BoundManageCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/13.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HorizontalImageTextView,TextIconModel;

@interface BoundManageCell : UITableViewCell

@property (nonatomic, strong) HorizontalImageTextView *nameV;
@property (nonatomic, strong) UILabel *detailLab;

- (void)setData:(TextIconModel *)model;

@end
