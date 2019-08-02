//
//  UserController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "UserController.h"
#import "UIAlertController+Extension.h"
#import "CenterToolView.h"
#import "VerticalImageTextView.h"
#import "MYCenterHeader.h"
#import "LogoutCell.h"
#import "CenterCell.h"
#import "LogoutUnbindCell.h"

#import "MyFriendViewController.h"
#import "CollectionRootController.h"
#import "ThreadRootController.h"
#import "LoginController.h"
#import "BoundManageController.h"
#import "PmListController.h"
#import "SettingViewController.h"
#import "FootRootController.h"
#import "ResetPwdController.h"

#import "TextIconModel.h"
#import "CenterUserInfoView.h"
#import "CenterManageModel.h"

#import "ImagePickerView.h"
#import "MessageNoticeCenter.h"
#import "UIImage+Limit.h"

@interface UserController ()

@property (nonatomic, strong) MYCenterHeader *myHeader;

@property (nonatomic, assign) NSInteger failureTime;

@property (nonatomic, strong) NSMutableDictionary *iwechat_user;

@property (nonatomic, strong) CenterManageModel *centerModel;

// 相机相册
@property (nonatomic, strong) ImagePickerView *pickerView;

@end

@implementation UserController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavc];
    self.failureTime = 0;
    
    // 135 + 85
    self.myHeader = [[MYCenterHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 220)];
    self.tableView.tableHeaderView = self.myHeader;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAvatar)];
    [self.myHeader.userInfoView.headView addGestureRecognizer:tapGes];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    [self tooBarAction];
    
    [self initData];
    
    [self.HUD showLoadingMessag:@"拉取信息" toView:self.view];
    [self downLoadData];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
        [weakSelf downLoadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiReloadData) name:REFRESHCENTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signout) name:SIGNOUTNOTIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiReloadData) name:DOMAINCHANGE object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置导航栏
-(void)setNavc{
    
    [self createBarBtn:@"" type:NavItemText Direction:NavDirectionLeft];
    [self createBarBtn:@"setting" type:NavItemImage Direction:NavDirectionRight];
    
    self.title = @"我的";
}

- (void)rightBarBtnClick {
    
    SettingViewController * svc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)notiReloadData {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self downLoadData];
}

- (void)initData {
    
    self.centerModel = [[CenterManageModel alloc] initWithType:JTCenterTypeMy];
}

// toobar 点击事件
- (void)tooBarAction {
    WEAKSELF;
    self.myHeader.tooView.toolItemClickBlock = ^(VerticalImageTextView *sender, NSInteger index, NSString *name) {
        
        if (![weakSelf isLogin]) {
            return;
        }
        switch (index) {
            case 0:          //我的好友
            {
                MyFriendViewController *mfvc = [[MyFriendViewController alloc] init];
                [weakSelf.navigationController pushViewController:mfvc animated:YES];
            }
                break;
            case 1:          //我的收藏
            {
                CollectionRootController *mfvc = [[CollectionRootController alloc] init];
                [weakSelf.navigationController pushViewController:mfvc animated:YES];
            }
                break;
            case 2:          //我的提醒
            {

                PmListController *pmVC = [[PmListController alloc] init];
                [weakSelf.navigationController pushViewController:pmVC animated:YES];
            }
                break;
            case 3:          //我的主题
            {
                ThreadRootController *trVc = [[ThreadRootController alloc] init];
                trVc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:trVc animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    };
}

-(void)downLoadData {
    
    [self initData];
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.methodType = JTMethodTypePOST;
        request.urlString = url_UserInfo;
    } success:^(id responseObject, JTLoadType type) {
        self.failureTime = 0;
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        
        DLog(@"%@",responseObject);
        
        if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"] isEqualToString:@"请先登录后才能继续浏览"]) {
            [self signout];
            [self initLogin];
            return ;
        } else if ([DataCheck isValidString:[responseObject objectForKey:@"error"]]){
            if ([[responseObject objectForKey:@"error"] isEqualToString:@"user_banned"]) {
                [MBProgressHUD showInfo:@"用户被禁止"];
            }
            [self signout];
            [self initLogin];
            return;
        }
        [self.centerModel dealData:responseObject];
        [Environment sharedEnvironment].member_avatar = [self.centerModel.myInfoDic objectForKey:@"member_avatar"];
        self.myHeader.userInfoView.nameLab.text = [[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"username"];
        [self.myHeader.userInfoView setIdentityText:[[[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"group"] objectForKey:@"grouptitle"]];
        [self.myHeader.userInfoView.headView sd_setImageWithURL:[NSURL URLWithString:[Environment sharedEnvironment].member_avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRefreshCached];
        
        if ([DataCheck isValidDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"iwechat_user"]]) {
            self.iwechat_user = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"iwechat_user"]];
        }
        
        DLog(@"AAA%@",self.centerModel.myInfoDic);
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        self.failureTime ++;
        if (self.failureTime == 5) {
            [self signout];
            [self initLogin];
        }
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        [self showServerError:error];
        [self.tableView reloadData];
        
    }];
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            return 0.1;  // 把第一个用户组给隐藏了
        }
    }
    else if (indexPath.section == 2) {
        return 60;
    }
    return 50.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        
        return self.centerModel.manageArr.count;
        
    } else if (section == 1) {
        
        return self.centerModel.infoArr.count;
        
    } else if (self.centerModel.myInfoDic.count > 0) {
        
        return 1;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CenterID";
    static NSString *LogoutID = @"LogoutID";
    static NSString *UnbindID = @"UnbindID";
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[CenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        TextIconModel *model;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.section == 0) {
            
            
            if (indexPath.row == 1 || indexPath.row == 2) {
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            model = self.centerModel.manageArr[indexPath.row];
            
        } else if (indexPath.section == 1) {
            if (self.centerModel.infoArr.count > indexPath.row) {
                model = self.centerModel.infoArr[indexPath.row];
            }
        }
        [cell setData:model];
        return cell;
        
    } else {
        
        
        if ([self isUnbindShow]) {
            LogoutUnbindCell *cell = [tableView dequeueReusableCellWithIdentifier:UnbindID];
            if (cell == nil) {
                cell = [[LogoutUnbindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UnbindID];
                UITapGestureRecognizer *logoutGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signoutAction)];
                [cell.logoutLab addGestureRecognizer:logoutGes];
                UITapGestureRecognizer *unbindGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unBindAction)];
                [cell.unbindLab addGestureRecognizer:unbindGes];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:LogoutID];
        if (cell == nil) {
            cell = [[LogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LogoutID];
        }
        
        cell.lab.text = @"退出";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return;
            BoundManageController *boundVc = [[BoundManageController alloc] init];
            boundVc.myInfoDic = self.centerModel.myInfoDic;
            WEAKSELF;
            boundVc.refreshBlock = ^{
                [weakSelf downLoadData];
            };
            [self showViewController:boundVc sender:nil];
        }
        
        if (indexPath.row == 1) {
            ResetPwdController *restVc = [[ResetPwdController alloc] init];
            restVc.hidesBottomBarWhenPushed = YES;
            [self showViewController:restVc sender:nil];
        }
        
        if (indexPath.row == 2) {
            FootRootController *footRvc = [[FootRootController alloc] init];
            footRvc.hidesBottomBarWhenPushed = YES;
            [self showViewController:footRvc sender:nil];
        }
    }
    
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([self isUnbindShow]) {
            return;
        }
        
        NSString *message = @"您确定退出？退出将不能体验全部功能。";
        NSString *donetip = @"退出";
        
        [UIAlertController alertTitle:@"提示" message:message controller:self doneText:donetip cancelText:@"取消" doneHandle:^{
            [self signout];
        } cancelHandle:nil];
    }
}

- (BOOL)isUnbindShow {
    if ([LoginModule isThirdplatformLogin]) {
        if ([[Environment sharedEnvironment].member_loginstatus isEqualToString:@"qq"] && [DataCheck isValidString:[self.iwechat_user objectForKey:@"qqopenid"]]) {
            return YES;
        } else if(([[Environment sharedEnvironment].member_loginstatus isEqualToString:@"weixin"] && [DataCheck isValidString:[self.iwechat_user objectForKey:@"unionid"]])) {
            return YES;
        }
    }
    return NO;
}

- (void)unBindAction {
    NSString *type;
    if ([[Environment sharedEnvironment].member_loginstatus isEqualToString:@"qq"]) {
        type = @"QQ";
    } else if ([[Environment sharedEnvironment].member_loginstatus isEqualToString:@"weixin"]) {
        type = @"微信";
    }
    NSString *message = [NSString stringWithFormat:@"您确定解除绑定？解除后将无法使用该%@登录此账号",type];
    NSString *donetip = @"确定";
    
    [UIAlertController alertTitle:@"提示" message:message controller:self doneText:donetip cancelText:@"取消" doneHandle:^{
        [self unBind];
    } cancelHandle:nil];
}

- (void)signoutAction {
    NSString *message = @"您确定退出？退出将不能体验全部功能。";
    NSString *donetip = @"确定";
    [UIAlertController alertTitle:@"提示" message:message controller:self doneText:donetip cancelText:@"取消" doneHandle:^{
        [self signout];
    } cancelHandle:nil];
}

- (void)unBind {
    
    if ([LoginModule isThirdplatformLogin]) {
        
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            NSDictionary *getDic = @{@"type":[Environment sharedEnvironment].member_loginstatus};
            [self.HUD showLoadingMessag:@"解除绑定" toView:self.view];
            request.parameters = getDic;
            request.urlString = url_unBindThird;
        } success:^(id responseObject, JTLoadType type) {
            [self.HUD hideAnimated:YES];
            DLog(@"%@",[responseObject objectForKey:@"Message"]);
            if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Message"]]) {
                NSDictionary *msgDic = [responseObject objectForKey:@"Message"];
                if ([DataCheck isValidString:[msgDic objectForKey:@"messageval"]]) {
                    NSString *messageStatus = [msgDic objectForKey:@"messageval"];
                    if ([messageStatus containsString:@"success"]) {
                        
                        [LoginModule cleanLogType];
                        
                        [self.tableView reloadData];
                        return;
                    }
                    
                    [MBProgressHUD showInfo:[msgDic objectForKey:@"messageval"]];
                }
                
            }
            
            [MBProgressHUD showInfo:@"对不起，解绑失败"];
            
        } failed:^(NSError *error) {
            [self.HUD hideAnimated:YES];
        }];
    }
}

- (void)modifyAvatar {
    WEAKSELF;
    self.pickerView.finishPickingBlock = ^(UIImage *image) {
        [weakSelf uploadImage:image];
    };
    [self.pickerView openSheet];
    
}

- (void)uploadImage:(UIImage *)image {
    
    [self.HUD showLoadingMessag:@"上传中" toView:self.view];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        
        NSData *data = [image limitImageSize];
        NSString *nowTime = [[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", nowTime];
        [request addFormDataWithName:@"Filedata" fileName:fileName mimeType:@"image/png" fileData:data];
        
        request.urlString = url_UploadHead;
        request.methodType = JTMethodTypeUpload;
    } progress:^(NSProgress *progress) {
        if (100.f * progress.completedUnitCount/progress.totalUnitCount == 100) {
            //            complete?complete():nil;
        }
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        id resDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([DataCheck isValidDictionary:resDic] && [[[resDic objectForKey:@"Variables"] objectForKey:@"uploadavatar"] containsString:@"success"] ) {
            [MBProgressHUD showInfo:@"上传成功"];
            self.myHeader.userInfoView.headView.image = image;
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [MBProgressHUD showInfo:@"上传失败"];
    }];
}

- (void)signout {
    DLog(@"退出");
    self.failureTime = 0;
    [LoginModule signout];
    [self initData];
    [self.tableView reloadData];
    [self initLogin];
    [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTIONFORUMREFRESH object:nil];
}

- (void)initLogin {
    
    LoginController *login = [[LoginController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nc animated:YES completion:nil];
}

- (NSMutableDictionary *)iwechat_user {
    if (!_iwechat_user) {
        _iwechat_user = [NSMutableDictionary dictionary];
    }
    return _iwechat_user;
}

- (ImagePickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[ImagePickerView alloc] init];
        _pickerView.navigationController = self.navigationController;
    }
    return _pickerView;
}

@end
