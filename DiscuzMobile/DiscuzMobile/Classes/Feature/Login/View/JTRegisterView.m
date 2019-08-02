//
//  JTRegisterView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/11.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "JTRegisterView.h"
#import "LoginCustomView.h"
#import "JTQuestionAnswerView.h"
#import "Web2AuthcodeView.h"

#define TEXTHEIGHT 50

@implementation JTRegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self P_setupViews];
    }
    return self;
}

- (void)P_setupViews {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *nameImageV = [[UIImageView alloc] init];
    nameImageV.image = [UIImage imageNamed:LOGONAME];
    nameImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:nameImageV];
    [nameImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(50);
#if Penjing
        make.width.mas_equalTo(310);
        make.height.mas_equalTo(50);
#else
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(35);
#endif
    }];
    
    IQPreviousNextView *contentView = [[IQPreviousNextView alloc] init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor redColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat cwidth = CGRectGetWidth(self.frame) - 80;
        make.width.mas_equalTo(cwidth);
        make.top.equalTo(nameImageV.mas_bottom).offset(50);
//        make.height.mas_equalTo(200);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    
    self.usernameView = [[LoginCustomView alloc] init];
    self.usernameView.userNameTextField.tag = 101;
    self.usernameView.userNameTextField.delegate = self;
    self.usernameView.imgView.image = [UIImage imageNamed:@"log_u"];
    self.usernameView.userNameTextField.placeholder = @"用户名为3-15位";
    [contentView addSubview:self.usernameView];
    [self.usernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView);
        make.top.equalTo(contentView.mas_top);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(contentView.mas_left);
    }];
    
    self.passwordView = [[LoginCustomView alloc] init];
    self.passwordView.userNameTextField.tag = 102;
    self.passwordView.userNameTextField.delegate = self;
    self.passwordView.userNameTextField.placeholder = @"密码";
    self.passwordView.userNameTextField.secureTextEntry = YES;
    self.passwordView.imgView.image = [UIImage imageNamed:@"log_p"];
    [contentView addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.usernameView.mas_width);
        make.top.equalTo(self.usernameView.mas_bottom);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(self.usernameView.mas_left);
    }];
    
    self.repassView = [[LoginCustomView alloc] init];
    self.repassView.userNameTextField.placeholder = @"重复密码";
    self.repassView.imgView.image = [UIImage imageNamed:@"log_r"];
    self.repassView.userNameTextField.tag = 103;
    self.repassView.userNameTextField.secureTextEntry = YES;
    self.repassView.userNameTextField.delegate = self;
    [contentView addSubview:self.repassView];
    [self.repassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.passwordView.mas_width);
        make.top.equalTo(self.passwordView.mas_bottom);
        make.height.mas_equalTo(TEXTHEIGHT);
        make.left.equalTo(self.passwordView.mas_left);
    }];
    
    self.emailView = [[LoginCustomView alloc] init];
    [contentView addSubview:self.emailView];
    self.emailView.backgroundColor = [UIColor whiteColor];
    self.emailView.imgView.image = [UIImage imageNamed:@"log_e"];
    self.emailView.userNameTextField.placeholder = @"邮箱";
    self.emailView.userNameTextField.delegate = self;
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.repassView);
        make.top.equalTo(self.repassView.mas_bottom);
        make.width.equalTo(self.repassView.mas_width);
        make.height.mas_equalTo(TEXTHEIGHT);
    }];
    
//    self.questAnswerView = [[JTQuestionAnswerView alloc] init];
//    self.questAnswerView.logoV.image = [UIImage imageNamed:@"log_s"];
//    self.questAnswerView.answerField.delegate = self;
//    self.questAnswerView.hidden = YES;
//    [self addSubview:self.questAnswerView];
//    [self.questAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(contentView);
//        make.top.equalTo(contentView.mas_bottom).offset(30);
//        make.width.equalTo(contentView.mas_width);
//        make.height.mas_equalTo(0);
//    }];
    
    // 验证码 有无
    self.authcodeView = [[Web2AuthcodeView alloc] init];
    self.authcodeView.hidden = YES;
    self.authcodeView.textField.delegate = self;
    [contentView addSubview:self.authcodeView];
    [self.authcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.emailView);
        make.top.equalTo(self.emailView.mas_bottom);
        make.width.equalTo(self.emailView.mas_width);
        make.height.mas_equalTo(0);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authcodeView);
    }];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerButton.cs_acceptEventInterval = 1;
    [self addSubview:self.registerButton];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.backgroundColor = MAIN_COLLOR;
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(self.authcodeView.mas_bottom).offset(16);
        make.width.mas_equalTo(contentView.mas_width);
        make.height.mas_equalTo(45);
    }];
    
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = 5.0;
    
    [self.registerButton layoutIfNeeded];
    
    _usertermsView = [[UsertermsView alloc] init];
    [self addSubview:_usertermsView];
////    [self.usertermsView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.registerButton);
////        make.top.equalTo(self.registerButton.mas_bottom).offset(10);
////        make.width.mas_equalTo(WIDTH - 20);
////        make.height.mas_equalTo(44);
////    }];
//    
//    CGFloat contentHeight = self.frame.size.height - 63;
//    if (CGRectGetMaxY(_usertermsView.frame) > contentHeight) {
//        contentHeight = CGRectGetMaxY(_usertermsView.frame) + 1;
//    }
//    self.contentSize = CGSizeMake(WIDTH, contentHeight);
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _usertermsView.frame = CGRectMake(CGRectGetMinX(_registerButton.frame), CGRectGetMaxY(_registerButton.frame) + 10, WIDTH, 44);
    CGFloat contentHeight = self.frame.size.height + 1;
    if (CGRectGetMaxY(_usertermsView.frame) + 50 > contentHeight) {
        contentHeight = CGRectGetMaxY(_usertermsView.frame) + 50;
    }
    self.contentSize = CGSizeMake(WIDTH, contentHeight);
}

@end
