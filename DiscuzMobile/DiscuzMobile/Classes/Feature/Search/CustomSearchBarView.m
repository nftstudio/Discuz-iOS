//
//  CustomSearchBarView.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/22.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import "CustomSearchBarView.h"

@implementation CustomSearchBarView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.cancelBtn];
    self.searchBar = [[TTSearchBar alloc] initWithFrame:CGRectMake(5, 1, CGRectGetWidth(self.frame) - 65, CGRectGetHeight(self.frame) - 2)];
    [self addSubview:self.searchBar];
    
    self.cancelBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 60, 0, 60, CGRectGetHeight(self.frame));
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.cancelBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 50, CGRectGetHeight(self.frame));
//    self.searchBar.frame = CGRectMake(0, 1, CGRectGetWidth(self.frame) - 50, CGRectGetHeight(self.frame) - 2);
    DLog(@"%lf",self.frame.size.width);
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_cancelBtn setTitleColor:MAIN_TITLE_COLOR forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

@end
