//
//  ViewPollpotionCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/25.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "ViewPollpotionCell.h"
#import "UIButton+WebCache.h"
#import "FontSize.h"

@implementation ViewPollpotionCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
    

    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 16, 40, 40)];
//    _headImageView.layer.cornerRadius = 4.0;
    _headImageView.layer.cornerRadius = CGRectGetWidth(self.headImageView.frame) / 2;
    _headImageView.layer.masksToBounds = YES;
    [self addSubview:self.headImageView];
    
    CGRect frame = self.headImageView.frame;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20+10, CGRectGetMinY(self.headImageView.frame), 190, 40)];
    self.nameLabel.font =[FontSize HomecellTitleFontSize15];
    [self addSubview:self.nameLabel];
    
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _messageBtn.frame=CGRectMake(WIDTH-95+20, 10+10,60, 30);
    _messageBtn.layer.cornerRadius = 3.0;
    _messageBtn.layer.borderWidth = 1.0;
    [_messageBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
    _messageBtn.layer.borderColor = MAIN_COLLOR.CGColor;
    [_messageBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [_messageBtn addTarget:self action:@selector(messageOnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_messageBtn];
}
-(void)messageOnAction:(UIButton *)btn{
    NSLog(@"messageOnAction");
    
    if ([self.delegate respondsToSelector:@selector(ViewPollpotionCellClick:)]) {
        [self.delegate performSelector:@selector(ViewPollpotionCellClick:) withObject:self];
    }
}
-(void)setdata:(NSDictionary*)dic{
    
    if ([DataCheck isValidString:[dic objectForKey:@"username"]]) {
          self.nameLabel.text = [dic objectForKey:@"username"];
    }else{
        self.nameLabel.text = @"游客 不能发消息";
    }
    NSURL * url =[NSURL URLWithString:[dic objectForKey:@"avatar"]];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noavatar_small"]];
}

-(CGFloat)cellheigh{

    return self.headImageView.frame.origin.y +self.headImageView.frame.size.height+10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
