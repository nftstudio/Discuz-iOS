//
//  LoginController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/10.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "LoginController.h"

#import <ShareSDK/ShareSDK.h>

#import "LoginModule.h"

#import "JTRegisterController.h"
#import "TTJudgeBoundController.h"

#import "JTLoginView.h"
#import "LoginCustomView.h"
#import "ZHPickView.h"

#import "ShareCenter.h"
#import "XinGeCenter.h"  // 信鸽
#import "CheckHelper.h"

#define TEXTHEIGHT 50

NSString * const debugUsername = @"debugUsername";
NSString * const debugPassword = @"debugPassword";

@interface LoginController ()<UITextFieldDelegate,ZHPickViewDelegate>{
    BOOL isQCreateView;  // 是否有安全问答
}

@property (nonatomic, strong) JTLoginView *logView;
@property (nonatomic, strong) NSString *preSalkey;

@end


@implementation LoginController

- (void)loadView {
    [super loadView];
    self.logView = [[JTLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.logView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarBtn];
    [[CheckHelper shareInstance] checkRequest];
    WEAKSELF;
    self.logView.authcodeView.refreshAuthCodeBlock = ^{
        [weakSelf downlodyan];
    };
    
    [self downlodyan];
    [self setViewDelegate];
    [self setViewAction];
    
    isQCreateView = NO;
    
#if DEBUG
    [self seupAutoButton];
#endif
}

- (void)seupAutoButton {
#if DEBUG
    if ([self isHaveFullContent]) {
        UIButton *autoFullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        autoFullBtn.frame = CGRectMake(WIDTH - 60, 20, 40, 20);
        [autoFullBtn addTarget:self action:@selector(isHaveFullContent) forControlEvents:UIControlEventTouchUpInside];
        autoFullBtn.titleLabel.font = [FontSize messageFontSize14];
        [autoFullBtn setTitle:@"填充" forState:UIControlStateNormal];
        autoFullBtn.layer.borderWidth = 1;
        [autoFullBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
        [self.view addSubview:autoFullBtn];
    }
#endif
}

- (BOOL)isHaveFullContent {
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userdefault objectForKey:debugUsername];
    NSString *password = [userdefault objectForKey:debugPassword];
    if ([DataCheck isValidString:username] && [DataCheck isValidString:password]) {
        self.logView.countView.userNameTextField.text = username;
        self.logView.pwordView.userNameTextField.text = password;
        return YES;
    }
    return NO;
}

- (void)setViewDelegate {
    self.logView.delegate = self;
    self.logView.pickView.delegate = self;
    
    self.logView.countView.userNameTextField.delegate = self;
    self.logView.pwordView.userNameTextField.delegate = self;
    self.logView.securityView.userNameTextField.delegate = self;
    self.logView.answerView.userNameTextField.delegate = self;
    self.logView.authcodeView.textField.delegate = self;
}

- (void)setViewAction {
    [self.logView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.logView.forgetBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.logView.qqBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:(UIControlEventTouchUpInside)];
    [self.logView.wechatBtn addTarget:self action:@selector(loginWithWeiXin) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 账号密码登录
-(void)loginBtnClick {
    DLog(@"登录咯");
    [self.view endEditing:YES];
    
    NSString *username = self.logView.countView.userNameTextField.text;
    NSString *password = self.logView.pwordView.userNameTextField.text;
    
    if (![DataCheck isValidString:username]) {
        
        [MBProgressHUD showInfo:@"请输入用户名"];
    } else if (![DataCheck isValidString:password]) {
        
        [MBProgressHUD showInfo:@"请输入密码"];
    } else {
        //       gei  &seccodeverify  验证码  &sechash={sechash值}    http header中加入之前获取到的saltkey,  coolkes
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:username forKey:@"username"];
        [dic setValue:password forKey:@"password"];
        [dic setValue:@"yes" forKey:@"loginsubmit"];
        if (self.verifyView.isyanzhengma) {
            [dic setValue:self.logView.authcodeView.textField.text forKey:@"seccodeverify"];
            [dic setValue:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
        }
        if (isQCreateView) {
            
            NSDictionary * dicvalue = @{@"母亲的名字":@"1",
                                        @"爷爷的名字":@"2",
                                        @"父亲出生的城市":@"3",
                                        @"您其中一位老师的名字":@"4",
                                        @"您个人计算机的型号":@"5",
                                        @"您最喜欢的餐馆名称":@"6",
                                        @"驾驶执照最后四位数字":@"7"};
            
            [dic setValue:[dicvalue objectForKey:self.logView.securityView.userNameTextField.text] forKey:@"questionid"];
            [dic setValue:self.logView.answerView.userNameTextField.text forKey:@"answer"];
        }
        [dic setValue:[Environment sharedEnvironment].formhash forKey:@"formhash"];
        DLog(@"%@",dic);
//        if ([DataCheck isValidString:self.preSalkey]) {
//            [dic setValue:self.preSalkey forKey:@"saltkey"];
//        }
        
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            request.methodType = JTMethodTypePOST;
            request.urlString = url_CommonLogin;
            request.parameters = dic;
            [self.HUD showLoadingMessag:@"登录中" toView:self.view];
        } success:^(id responseObject, JTLoadType type) {
            DLog(@"%@",responseObject);
            [self.HUD hideAnimated:NO];
            if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Message"]] && [[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"] isEqualToString:@"login_question_empty"]) {
                [self.logView.securityView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(TEXTHEIGHT);
                    self.logView.securityView.hidden = NO;
                }];
                [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
            } else {
                [self setUserInfo:responseObject];
#if DEBUG
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:username forKey:debugUsername];
                [userdefault setObject:password forKey:debugPassword];
                [userdefault synchronize];
#endif
            }
            
        } failed:^(NSError *error) {
            [self.HUD hideAnimated:YES];
            [self showServerError:error];
            
        }];
    }
}

#pragma mark - qq登录
- (void)loginWithQQ {
    
    [[ShareCenter shareInstance] loginWithQQSuccess:^(id  _Nullable response) {
        [self thirdConnectWithService:response];
    }];
    
}

#pragma mark - 微信登录
- (void)loginWithWeiXin {
    
    [[ShareCenter shareInstance] loginWithWeiXinSuccess:^(id  _Nullable response) {
        [self thirdConnectWithService:response];
    }];
    
}

- (void)thirdConnectWithService:(NSDictionary *)dic {
    DLog(@"openid等==========================%@",dic);
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"拉取信息" toView:self.view];
        request.urlString = url_ThirdLogin;
        request.methodType = JTMethodTypePOST;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        DLog(@"%@",responseObject);
        [self.HUD hideAnimated:YES];
        [self setUserInfo:responseObject];
    } failed:^(NSError *error) {
        [self.HUD hideAnimated:YES];
        [self showServerError:error];
        
        if ([[dic objectForKey:@"type"] isEqualToString:@"weixin"]) {
            if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            }
        }
    }];
}

#pragma mark - 请求成功操作
- (void)setUserInfo:(id)responseObject {
    
    NSString *messagestatus;
    if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Message"]]) {
        messagestatus = [[responseObject objectForKey:@"Message"] objectForKey:@"messagestatus"];
    }

    [super setUserInfo:responseObject];
    
    if ([messagestatus isEqualToString:@"0"]){
        // 去第三方绑定页面
        [self boundThirdview];
    }
    
}


-(void)createBarBtn{
    [self createBarBtn:@"back" type:NavItemImage Direction:NavDirectionLeft];
    [self createBarBtn:@"注册" type:NavItemText Direction:NavDirectionRight];
    
    self.navigationItem.title = @"";
}

- (void)leftBarBtnClick {
    [self.view endEditing:YES];
    NSDictionary *userInfo = @{@"type":@"cancel"};
    [[NSNotificationCenter defaultCenter] postNotificationName:SETSELECTINDEX object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 注册
- (void)rightBarBtnClick {
    [self.view endEditing:YES];
    [self registerNavview];
}

- (void)registerNavview {
    // 重置一下
    [ShareCenter shareInstance].bloginModel = nil;
    JTRegisterController * rvc =[[JTRegisterController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}


- (void)boundThirdview {
    
    TTJudgeBoundController * rvc =[[TTJudgeBoundController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)findPassword:(UIButton *)sender {
    
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"login" success:^{
        
        if (self.verifyView.isyanzhengma) {
            [self.logView.authcodeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TEXTHEIGHT);
            }];
            self.logView.authcodeView.hidden = NO;
            [self loadSeccodeImage];
        }
        
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
}

- (void)loadSeccodeImage {
    
    [self performSelector:@selector(loadSeccodeWebView) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}


- (void)loadSeccodeWebView {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.verifyView.secureData objectForKey:@"seccode"]]];
    DLog(@"%@",[self.verifyView.secureData objectForKey:@"seccode"]);
    [self.logView.authcodeView.webview loadRequest:request];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag==103) {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    } else {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }
    return YES;
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString androw:(NSInteger)row{
    
    self.logView.securityView.userNameTextField.text = resultString;
    
    if ([DataCheck isValidString:resultString] && ![resultString isEqualToString:@"无安全提问"]) {
        
        [self.logView.answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(TEXTHEIGHT);
        }];
        self.logView.answerView.hidden = NO;
    } else {
        [self.logView.answerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        self.logView.answerView.hidden = YES;
    }
    if (![self.logView.securityView.userNameTextField.text isEqualToString:@"无安全提问"]) {
        // 创建view
        isQCreateView = YES;

    } else {
        
        isQCreateView = NO;
    }
}


@end
