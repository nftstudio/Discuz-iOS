//
//  BoundManageCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/13.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "BoundManageCell.h"
#import "HorizontalImageTextView.h"
#import "TextIconModel.h"

@implementation BoundManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.nameV = [[HorizontalImageTextView alloc] init];
    [self.contentView addSubview:self.nameV];
    
    self.detailLab = [[UILabel alloc] init];
    //    self.detailLab.backgroundColor= [UIColor redColor];
    self.detailLab.textAlignment = NSTextAlignmentRight;
    self.detailLab.font = [FontSize HomecellTimeFontSize14];
    self.detailLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.detailLab];
}

- (void)setData:(TextIconModel *)model {
    if (model != nil) {
        
        self.nameV.textLabel.text = model.text;
        self.nameV.iconV.image = [UIImage imageNamed:model.iconName];
        self.detailLab.text = model.detail;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameV.frame = CGRectMake(15, 11, 200, CGRectGetHeight(self.frame) - 20);
    self.detailLab.frame = CGRectMake(WIDTH - 120 - 10, CGRectGetMinY(self.nameV.frame), 120, CGRectGetHeight(self.nameV.frame));
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
