//
//  JTRegisterController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/11.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "JTRegisterController.h"
#import "JTRegisterView.h"
#import "XinGeCenter.h"
#import "AuthcodeView.h"
#import "LoginCustomView.h"
#import "JTQuestionAnswerView.h"
#import "UsertermsController.h"
#import "Web2AuthcodeView.h"

#import "CheckHelper.h"

@interface JTRegisterController ()

@property (nonatomic,strong) JTRegisterView *registerView;
@property (nonatomic, strong) NSString *bbrulestxt;
@end

@implementation JTRegisterController

- (void)loadView {
    
    [super loadView];
    
    _registerView = [[JTRegisterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view = _registerView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _registerView.delegate = self;
    [_registerView.registerButton addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    WEAKSELF;
    self.registerView.authcodeView.refreshAuthCodeBlock = ^{
        [weakSelf downlodyan];
    };
    
    [self downlodyan];
#pragma mark - 关闭验证码
    //    if (!self.bloginModel) {
    //        [self downlodyan];
    //    }
    [self checkRequest];
    
    self.registerView.usertermsView.readTermBlock = ^ {
        [weakSelf readTerms];
    };
}

- (void)checkRequest {
//    if (![DataCheck isValidString:[CheckHelper shareInstance].regUrl]) {
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [[CheckHelper shareInstance] checkRegisterRequestSuccess:^{
        [self.HUD hide];
    } failure:^{
        [self.HUD hide];
    }];
//    }
}

- (void)readTerms {
    UsertermsController *usertermsVc = [[UsertermsController alloc] init];
    usertermsVc.bbrulestxt = self.bbrulestxt;
    [self.navigationController pushViewController:usertermsVc animated:YES];
}

- (void)tapAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"register" success:^{
        if (self.verifyView.isyanzhengma) {
            [self.registerView.authcodeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
            }];
            self.registerView.authcodeView.hidden = NO;
        }
        
        self.bbrulestxt = [self.verifyView.secureData objectForKey:@"bbrulestxt"];
        
        [self loadSeccodeImage];
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
}


- (void)loadSeccodeImage {
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.verifyView.secureData objectForKey:@"seccode"]]];
    [self.registerView.authcodeView.webview loadRequest:request];
    
}

- (void)registerBtnClick {
    
    //    [self postRegistData];
    //
    //    return;
    
    [self.view endEditing:YES];
    
    if (!self.registerView.usertermsView.isAgree) {
        [MBProgressHUD showInfo:@"未同意服务条款"];
        return;
    }
    
    NSString *username = self.registerView.usernameView.userNameTextField.text;
    NSString *password = self.registerView.passwordView.userNameTextField.text;
    NSString *repass = self.registerView.repassView.userNameTextField.text;
    NSString *email = self.registerView.emailView.userNameTextField.text;
    
    if ([DataCheck isValidString:username] && [DataCheck isValidString:password] && [DataCheck isValidString:repass] && [DataCheck isValidString:email] && [DataCheck isValidString:password]) { // 全部按要求填了
        if (![password isEqualToString:repass]) {
            [MBProgressHUD showInfo:@"请确定两次输入的密码相同"];
        } else { // 所有都输入了，去注册
            [self postRegistData];
        }
    } else { // 未按要求填或者有空
        if (![DataCheck isValidString:username]) {
            [MBProgressHUD showInfo:@"请输入用户名"];
        } else if (![DataCheck isValidString:password]) {
            [MBProgressHUD showInfo:@"请输入密码"];
        } else if (![DataCheck isValidString:repass]) {
            [MBProgressHUD showInfo:@"请在确定密码框中再次输入密码"];
        } else if (![DataCheck isValidString:email]) {
            [MBProgressHUD showInfo:@"请输入邮箱"];
        }
    }
    
}

- (void)postRegistData {
    NSString *username = _registerView.usernameView.userNameTextField.text;
    NSString *password = _registerView.passwordView.userNameTextField.text;
    NSString *repass = _registerView.repassView.userNameTextField.text;
    NSString *email = _registerView.emailView.userNameTextField.text;
    
    if (![DataCheck isValidDictionary:[CheckHelper shareInstance].regKeyDic]) {
        [self checkRequest];
        [MBProgressHUD showInfo:@"正在获取注册配置，请稍候"];
        return;
    }
    
    NSMutableDictionary *getDic = @{[[CheckHelper shareInstance].regKeyDic objectForKey:@"username"]:username,
                                    [[CheckHelper shareInstance].regKeyDic objectForKey:@"password"]:password,
                                    [[CheckHelper shareInstance].regKeyDic objectForKey:@"password2"]:repass,
                                    [[CheckHelper shareInstance].regKeyDic objectForKey:@"email"]:email,
                                    @"formhash":[Environment sharedEnvironment].formhash,
                                    }.mutableCopy;
    
    if (self.verifyView.isyanzhengma) {
        if ([DataCheck isValidString:self.registerView.authcodeView.textField.text]) {
            [getDic setValue:self.registerView.authcodeView.textField.text forKey:@"seccodeverify"];
            [getDic setValue:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
        }
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        
        if ([ShareCenter shareInstance].bloginModel.openid != nil) { // 三方登录过来的注册
            [getDic setValue:[ShareCenter shareInstance].bloginModel.logintype forKey:@"type"];
            [getDic setValue:[ShareCenter shareInstance].bloginModel.openid forKey:@"openid"];
            
            if ([[ShareCenter shareInstance].bloginModel.logintype isEqualToString:@"weixin"] && [DataCheck isValidString:[ShareCenter shareInstance].bloginModel.unionid]) {
                
                [getDic setValue:[ShareCenter shareInstance].bloginModel.unionid forKey:@"unionid"];
                
            }
            [self.HUD showLoadingMessag:@"登录中" toView:self.view];
            request.urlString = url_TirdRegister;
            
        } else { // 普通注册
            [self.HUD showLoadingMessag:@"注册中" toView:self.view];
            [getDic setValue:[Environment sharedEnvironment].formhash forKey:@"formhash"];
            request.urlString = [CheckHelper shareInstance].regUrl;
            [getDic setObject:@"yes" forKey:@"regsubmit"];
        }
        
        request.parameters = getDic;
        request.methodType = JTMethodTypePOST;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hideAnimated:YES];
        [self setUserInfo:responseObject];
    } failed:^(NSError *error) {
        [self showServerError:error];
        [self.HUD hideAnimated:YES];
    }];
    
}

@end

