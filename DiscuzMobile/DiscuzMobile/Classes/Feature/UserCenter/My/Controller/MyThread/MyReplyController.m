//
//  MyReplyController.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "MyReplyController.h"
#import "OtherUserPostReplyCell.h"
#import "ThreadViewController.h"
#import "ReplyCell.h"
#import "SubjectCell.h"

#import "ReplyModel.h"

@interface MyReplyController ()

@property (nonatomic, assign) NSInteger listcount;
@property (nonatomic, assign) NSInteger tpp;
@property (nonatomic, strong) NSMutableArray *replyArr;

@end

@implementation MyReplyController

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
    self.navigationItem.title = @"我的回复";
    
    _listcount = 0;
    _tpp = 0;
    
    [self downLoadData];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}

- (void)refreshData {
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self downLoadData];
}

- (void)addData {
    self.page ++;
    [self downLoadData];
}
#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75.0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
//    return self.replyArr.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellId = @"CellId";
    
    SubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[SubjectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    NSDictionary * dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    if ([DataCheck isValidDictionary:dic]) {
        [cell setData:dic];
    }
    return cell;
    
//    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
//    if (cell == nil) {
//        cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
//    }
//    ReplyModel *model = self.dataSourceArr[indexPath.row];
//    [cell setInfo:model];
//
//    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString * tid = [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"tid"];
//    NSString *fid = [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"fid"];
//    ThreadViewController * tvc = [[ThreadViewController alloc] init];
//    tvc.tid = tid;
//    tvc.strFourmID = fid;
    //    tvc.title =@"精彩热帖";
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * tid = [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"tid"];
    
//    ReplyModel *model = self.replyArr[indexPath.row];
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = tid;
    [self.navigationController pushViewController:tvc animated:YES];
    
}

-(void)downLoadData{
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"type":@"reply",
                              @"page":[NSString stringWithFormat:@"%ld",self.page]};
        request.urlString = url_Mythread;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        DLog(@"%@",responseObject);
        
        [self.HUD hideAnimated:YES];
//        if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"tpp"]]) {
//            _tpp = [[[responseObject objectForKey:@"Variables"] objectForKey:@"tpp"] integerValue];
//        }
//        if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"listcount"]]) {
//            _listcount = [[[responseObject objectForKey:@"Variables"] objectForKey:@"listcount"] integerValue];
//        }
//
//
//
//        if (self.page == 1) {
//            [self clearData];
//            [self.tableView.mj_header endRefreshing];
//            if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
//                self.dataSourceArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ]];
//                [self analysisData:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ]];
//            }
//
//            [self emptyShow];
//        } else {
//
//            [self.tableView.mj_footer endRefreshing];
//            if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
//                NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ];
//                [self.dataSourceArr addObjectsFromArray:arr];
//                [self analysisData:arr];
//            }
//        }
//
//        if (_listcount < _tpp) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"data"]]) {
            
            if (self.page == 1) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"data" ]];
                if (self.dataSourceArr.count < [[[responseObject objectForKey:@"Variables"] objectForKey:@"perpage" ] integerValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            } else {
                NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:@"data" ];
                [self.dataSourceArr addObjectsFromArray:arr];
                
                if (arr.count < [[[responseObject objectForKey:@"Variables"] objectForKey:@"perpage" ] integerValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        }
        [self emptyShow];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        DLog(@"%@",error);
        [self emptyShow];
        [self showServerError:error];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.HUD hideAnimated:YES];
    }];
    
}

- (void)analysisData:(NSArray *)dataArr {
    
    for (NSDictionary *dic in dataArr) {
        
        if ([DataCheck isValidArray:[dic objectForKey:@"reply"]]) {
            
            NSArray *arr = [dic objectForKey:@"reply"];
            
            for (NSDictionary *replyDic in arr) {
                
                ReplyModel *reply = [[ReplyModel alloc] init];
                [reply setValuesForKeysWithDictionary:replyDic];
                reply.auther = [dic objectForKey:@"auther"];
                reply.subject = [dic objectForKey:@"subject"];
                [self.replyArr addObject:reply];
            }
        }
    }
}

- (void)clearData {
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    if (self.replyArr.count > 0) {
        [self.replyArr removeAllObjects];
    }
    self.cellHeights = [NSMutableDictionary dictionary];
}

- (NSMutableArray *)replyArr {
    if (!_replyArr) {
        _replyArr = [NSMutableArray array];
    }
    return _replyArr;
}

@end
