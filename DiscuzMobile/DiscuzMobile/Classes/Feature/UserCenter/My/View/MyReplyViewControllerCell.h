//
//  MyReplyViewControllerCell.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/9/2.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReplyViewControllerCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

-(void)setData:(NSDictionary*)dic;
@end
