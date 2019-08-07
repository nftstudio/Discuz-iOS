//
//  JTQuestionAnswerView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/11.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "JTQuestionAnswerView.h"

@implementation JTQuestionAnswerView

//@property (nonatomic, strong) UIImageView *logoV;
//@property (nonatomic, strong) UILabel *tipLab;
//@property (nonatomic, strong) UILabel *questionLab;
//@property (nonatomic, strong) UITextField *answerField;
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.logoV];
    
    [self addSubview:self.tipLab];
    self.tipLab.text = @"验证问答：输入下面问题的答案";
    self.tipLab.font = [FontSize HomecellNameFontSize16];
    self.tipLab.textColor = [UIColor lightGrayColor];
    
    [self addSubview:self.questionLab];
    self.questionLab.text = @"13-3=?";
    self.questionLab.textAlignment = NSTextAlignmentRight;
    self.questionLab.font = [FontSize HomecellTitleFontSize17];
    self.questionLab.textColor = MAIN_TITLE_COLOR;
    
    [self addSubview:self.answerField];
    self.answerField.borderStyle = UITextBorderStyleRoundedRect;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.logoV.frame = CGRectMake(0, 0, 24, 24);
    self.tipLab.frame = CGRectMake(CGRectGetMaxX(self.logoV.frame) + 15, CGRectGetMinY(self.logoV.frame), CGRectGetWidth(self.frame) - 8, CGRectGetHeight(self.logoV.frame));
    self.questionLab.frame = CGRectMake(0, CGRectGetMaxY(self.logoV.frame) + 5, 80, 30);
    self.answerField.frame = CGRectMake(CGRectGetMaxX(self.questionLab.frame) + 8, CGRectGetMinY(self.questionLab.frame), CGRectGetWidth(self.frame) - 80 - 8, CGRectGetHeight(self.questionLab.frame));
}

- (UIImageView *)logoV {
    if (!_logoV) {
        _logoV = [[UIImageView alloc] init];
    }
    return _logoV;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
    }
    return _tipLab;
}

- (UILabel *)questionLab {
    if (!_questionLab) {
        _questionLab = [[UILabel alloc] init];
    }
    return _questionLab;
}

- (UITextField *)answerField {
    if (!_answerField) {
        _answerField = [[UITextField alloc] init];
    }
    return _answerField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
