//
//  CenterManageModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/9/8.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "CenterManageModel.h"
#import "TextIconModel.h"

@implementation CenterManageModel

- (instancetype)initWithType:(JTCenterType)type {
    self = [super init];
    if (self) {
        if (type == JTCenterTypeMy) {
            [self initData];
        } else if (type == JTCenterTypeOther) {
            [self initOtherData];
        }
    }
    return self;
}

- (void)initData {
//    NSArray *mgArr = @[@"账号设置",@"修改密码",@"我的足迹", @"注册时间"];
    NSArray *mgArr = @[@"注册时间"];
    for (int i = 0; i < mgArr.count; i ++) {
        TextIconModel *model = [[TextIconModel alloc] init];
        model.text = mgArr[i];
        switch (i) {
            case 0:
//                model.iconName = [NSString stringWithFormat:@"uclist_%d",i];
                model.iconName = [NSString stringWithFormat:@"uclist_%d",1];
                break;
            case 1:
                model.iconName = @"edit_pwd_icon";
                break;
            case 2:
                model.iconName = @"zuji";
                break;
            case 3:
                model.iconName = [NSString stringWithFormat:@"uclist_%d",i - 2];
                break;
                
            default:
                break;
        }
        
        [self.manageArr addObject:model];
    }
    
    [self setInfoArray];
}

- (void)initOtherData {
    
//    NSArray *uArr = @[@"他的主题 ",@"他的回复"];
    NSArray *uArr = @[];
    for (int i = 0; i < uArr.count; i ++) {
        TextIconModel *model = [[TextIconModel alloc] init];
        model.text = uArr[i];
        model.iconName = [NSString stringWithFormat:@"ucex_%d",i];
        [self.useArr addObject:model];
    }
    
    
    NSArray *manageArr = @[@"用户组", @"管理组", @"注册时间"];
    
    for (int i = 0; i < manageArr.count; i ++) {
        TextIconModel *model = [[TextIconModel alloc] init];
        model.text = manageArr[i];
        model.iconName = [NSString stringWithFormat:@"uclist_%d",i];
        if (i == 1) {
            model.iconName = [NSString stringWithFormat:@"uclist_%d",i + 1];
        }
        if (i == 2) {
            model.iconName = [NSString stringWithFormat:@"uclist_%d",i - 1];
        }
        
        [self.manageArr addObject:model];
    }
    
    [self setInfoArray];
}

- (void)setInfoArray {
    NSArray *InfoArr = @[@"主题数", @"回帖数",@"积分"];
    for (int i = 0; i < InfoArr.count; i ++) {
        TextIconModel *model = [[TextIconModel alloc] init];
        model.text = InfoArr[i];
        model.iconName = [NSString stringWithFormat:@"ucex_%d",i];
        [self.infoArr addObject:model];
    }
}

- (void)dealOtherData:(id)responseObject {
    _isOther = YES;
    [self dealData:responseObject];
}


- (void)dealData:(id)responseObject {
    NSDictionary *myInfoDic = [responseObject objectForKey:@"Variables"];
    self.myInfoDic = myInfoDic.mutableCopy;
    for (int i = 0; i < self.manageArr.count; i ++) {
        TextIconModel *model = self.manageArr[i];
        if (_isOther) {
            switch (i) {
                case 0:
                {
                    model.detail = [[[myInfoDic objectForKey:@"space"] objectForKey:@"group"] objectForKey:@"grouptitle"];
                }
                break;
                case 1:
                {
                    model.detail = [[[myInfoDic objectForKey:@"space"] objectForKey:@"admingroup"] objectForKey:@"grouptitle"];
                }
                break;
                case 2:
                {
                    model.detail = [[myInfoDic objectForKey:@"space"] objectForKey:@"regdate"];
                }
                break;
                
                default:
                break;
            }
        } else {
            switch (i) {
                case 0:
                {
//                    model.detail = @"";
                    model.detail = [[myInfoDic objectForKey:@"space"] objectForKey:@"regdate"];
                }
                break;
                case 1:
                {
                    model.detail = @"";
                }
                break;
                case 2:
                {
                    model.detail = [[myInfoDic objectForKey:@"space"] objectForKey:@"regdate"];
                }
                break;
                
                default:
                break;
            }
        }
    }
    for (int i = 0; i < self.infoArr.count; i ++) {
        TextIconModel *model = self.infoArr[i];
        switch (i) {
            case 0:
                model.detail = [[myInfoDic objectForKey:@"space"] objectForKey:@"threads"];
                break;
            case 1:
            {
                NSString *poststr = [[myInfoDic objectForKey:@"space"] objectForKey:@"posts"];
                NSString *threads = [[myInfoDic objectForKey:@"space"] objectForKey:@"threads"];
                NSInteger realPost = [poststr integerValue] - [threads integerValue];
                
                model.detail = [NSString stringWithFormat:@"%ld",realPost];
                
            }
                
                break;
            case 2:
                model.detail = [[myInfoDic objectForKey:@"space"] objectForKey:@"credits"];
                break;
            default:
                break;
        }
    }
    
    
    NSDictionary * extcreditsConfig = [myInfoDic objectForKey:@"extcredits"];
    NSMutableArray *extcreditsIndex = [NSMutableArray array];
    
    //从扩展积分设置中读取扩展积分的名称
    if ([DataCheck isValidDictionary:extcreditsConfig]) {
        int i = 0;
        for (NSString * extcreditsId in extcreditsConfig) {
            [extcreditsIndex addObject:extcreditsId];
            
            if ([DataCheck isValidString:[[extcreditsConfig objectForKey:extcreditsId] objectForKey:@"title"]]) {
                TextIconModel *model = [[TextIconModel alloc] init];
                model.iconName = [NSString stringWithFormat:@"ucex_%ld",self.infoArr.count];
                model.text = [[extcreditsConfig objectForKey:extcreditsId] objectForKey:@"title"];
                model.detail = [NSString stringWithFormat:@"%@", [[myInfoDic objectForKey:@"space"] objectForKey:[NSString stringWithFormat:@"extcredits%@",extcreditsIndex[i]]]];
                [self.infoArr addObject:model];
                i ++;
            }
            
        }
    }
}


- (NSMutableArray<TextIconModel *> *)infoArr {
    if (!_infoArr) {
        _infoArr = [NSMutableArray array];
    }
    return _infoArr;
}

- (NSMutableArray<TextIconModel *> *)manageArr {
    if (!_manageArr) {
        _manageArr = [NSMutableArray array];
    }
    return _manageArr;
}

- (NSMutableArray<TextIconModel *> *)useArr {
    if (!_useArr) {
        _useArr = [NSMutableArray array];
    }
    return _useArr;
}

@end
