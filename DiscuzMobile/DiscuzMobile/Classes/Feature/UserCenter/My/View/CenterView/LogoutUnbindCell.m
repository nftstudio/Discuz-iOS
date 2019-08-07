//
//  LogoutUnbindCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LogoutUnbindCell.h"

@implementation LogoutUnbindCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.unbindLab = [self btnLab];
    self.unbindLab.text = @"解绑";
    [self.contentView addSubview:self.unbindLab];
    
    self.logoutLab = [self btnLab];
    self.logoutLab.text = @"退出";
    [self.contentView addSubview:self.logoutLab];
}

- (UILabel *)btnLab {
    UILabel *lab = [[UILabel alloc] init];
    lab.userInteractionEnabled = YES;
    lab.backgroundColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [FontSize HomecellTitleFontSize17];
    lab.textColor = LIGHT_TEXT_COLOR;
    return lab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.unbindLab.frame = CGRectMake(15, 5, (WIDTH  - 45) / 2, 50);
    [self setRadius:self.unbindLab];
    
    self.logoutLab.frame = CGRectMake(CGRectGetMaxX(self.unbindLab.frame) + 15, 5, (WIDTH  - 45) / 2, 50);
    [self setRadius:self.logoutLab];
    
}


- (void)setRadius:(UILabel *)lab {
    lab.layer.borderColor = NAV_SEP_COLOR.CGColor;
    lab.layer.borderWidth = 0.5;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 8;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
