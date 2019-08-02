//
//  BoundManageController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/12.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "BoundManageController.h"
#import "CenterUserInfoView.h"
#import "BoundManageCell.h"
#import "TextIconModel.h"
#import "BoundInfoModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@interface BoundManageController ()

@property (nonatomic, strong) CenterUserInfoView *userInfoView;
@property (nonatomic, strong) BoundInfoModel *boundInfoModel;

@end

@implementation BoundManageController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfoView = [[CenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 135)];
    self.tableView.tableHeaderView = self.userInfoView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    self.userInfoView.nameLab.text = [[self.myInfoDic objectForKey:@"space"] objectForKey:@"username"];
    [self.userInfoView setIdentityText:[[[self.myInfoDic objectForKey:@"space"] objectForKey:@"group"] objectForKey:@"grouptitle"]];
    
    self.boundInfoModel = [[BoundInfoModel alloc] init];
    
    [self initDatasource];
}

- (void)initDatasource {
    
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    
    NSDictionary *iwechat_user = [self.myInfoDic objectForKey:@"iwechat_user"];
    [self.boundInfoModel setValuesForKeysWithDictionary:iwechat_user];
    
    NSString *wx_detail = @"绑定";
    NSString *wx_show = @"微信(未绑定)";
    if ([DataCheck isValidString:self.boundInfoModel.unionid]) {
        wx_detail = @"解绑";
        wx_show = @"微信(已绑定)";
    }
    TextIconModel *wx = [[TextIconModel alloc] initWithText:wx_show andIconName:@"bound_wx" andDetail:wx_detail];
    [self.dataSourceArr addObject:wx];
    
    NSString *qq_detail = @"绑定";
    NSString *qq_show = @"QQ(未绑定)";
    if ([DataCheck isValidString:self.boundInfoModel.qqopenid]) {
        qq_detail = @"解绑";
        qq_show = @"QQ(已绑定)";
    }
    TextIconModel *qq = [[TextIconModel alloc] initWithText:qq_show andIconName:@"bound_qq" andDetail:qq_detail];
    [self.dataSourceArr addObject:qq];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"BoundManageID";
    BoundManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[BoundManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.detailLab.textColor = [UIColor redColor];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boundTapAction:)];
        cell.detailLab.userInteractionEnabled = YES;
        cell.detailLab.tag = indexPath.row;
        [cell.detailLab addGestureRecognizer:tapGes];
    }
    
    TextIconModel *model = self.dataSourceArr[indexPath.row];
    [cell setData:model];
    
    return cell;
}

- (void)boundTapAction:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    NSInteger index = view.tag;
    
    NSString *type = @"weixin";
    if (index == 1) {
        type = @"qq";
    }
    TextIconModel *model = self.dataSourceArr[index];
    if ([model.detail isEqualToString:@"解绑"]) {
        
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            NSDictionary *getDic = @{@"type":type};
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
                        //                        [MBProgressHUD showInfo:@"解绑成功"];
                        [LoginModule cleanLogType];
                        if (self.refreshBlock) {
                            self.refreshBlock();
                        }
                        [self downLoadData];
                        return;
                    }
                    
                    [MBProgressHUD showInfo:[msgDic objectForKey:@"messageval"]];
                }
                
            }
            
            [MBProgressHUD showInfo:@"对不起，解绑失败"];
            
        } failed:^(NSError *error) {
            [self.HUD hideAnimated:YES];
        }];
        
    } else if ([model.detail isEqualToString:@"绑定"]) {
        
        if (type == 0) {
            [self loginWithPlatformType:SSDKPlatformTypeWechat];
        }
        else {
            [self loginWithPlatformType:SSDKPlatformTypeQQ];
        }
    }
}

- (void)loginWithPlatformType:(SSDKPlatformType)platformType {
    
    WEAKSELF;
    [ShareSDK getUserInfo:platformType
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
               
               if (state == SSDKResponseStateSuccess) {
                   
                   NSString *type = @"qq";
                   
                   NSDictionary *getDic = @{@"openid":user.uid,
                                            @"type":type,
                                            @"username":[Environment sharedEnvironment].member_username,
//                                            @"password":[Environment sharedEnvironment].loggedPassword
                                            
                                            };
                   
                   if (platformType == SSDKPlatformTypeWechat) {
                       type = @"weixin";
                       if ([DataCheck isValidString:[user.rawData objectForKey:@"unionid"]]) {
                           getDic = @{@"openid":[NSString stringWithFormat:@"%@&unionid=%@",user.uid,[user.rawData objectForKey:@"unionid"]],
                                      @"type":type,@"username":[Environment sharedEnvironment].member_username,
//                                      @"password":[Environment sharedEnvironment].loggedPassword
                                      
                                      };
                       }
                       
                   }
                   
                   [weakSelf boundData:getDic];
                   
               } else {
                   [MBProgressHUD showInfo:@"服务器繁忙请重试"];
               }
               }];
}

- (void)boundData:(NSDictionary *)getDic {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"绑定中" toView:self.view];
        request.urlString = url_BindThird;
        request.parameters = getDic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hideAnimated:YES];
        if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messagestatus"] isEqualToString:@"1"]) {
            [self downLoadData];
        } else {
            [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
        }
    } failed:^(NSError *error) {
        [self.HUD hideAnimated:YES];
    }];
}


-(void)downLoadData {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.methodType = JTMethodTypePOST;
        request.urlString = url_UserInfo;
    } success:^(id responseObject, JTLoadType type) {
        
        self.myInfoDic = [responseObject objectForKey:@"Variables"];
        [self initDatasource];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        [self.HUD hideAnimated:YES];
    }];
}


@end
