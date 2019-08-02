//
//  ViewPollpotionViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/24.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "ViewPollpotionViewController.h"
#import "ViewPollpotionCell.h"
#import "LoginController.h"
#import "SendMessageViewController.h"
#import "ResponseMessage.h"
#import "UIAlertController+Extension.h"

@interface ViewPollpotionViewController()<ViewPollpotionCellDelegate>

@property (strong,nonatomic)UITableView *tableview;
@property (strong,nonatomic)NSArray *array;
@property (strong,nonatomic)NSArray *arrayImage;

@end

@implementation ViewPollpotionViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self downLoadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * CellID= @"viewReplyCellID";
    ViewPollpotionCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[ViewPollpotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate=self;
    NSDictionary * dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    CGRect rect = cell.frame;
    [cell setdata:dic];
    rect.size.height = [cell cellheigh];
    cell.frame = rect;
    DLog(@"%f",rect.size.height);
    return cell;

}

-(void)ViewPollpotionCellClick:(ViewPollpotionCell *)cell{
    
    if (![self isLogin]) {
        return;
    }
    
    SendMessageViewController * senVC=[[SendMessageViewController alloc]init];
    
    if ([DataCheck isValidString:cell.nameLabel.text]) {
         senVC.uid = cell.nameLabel.text;
    }
    [self.navigationController pushViewController:senVC animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DLog(@"ViewPollpotionCelldidSelectRowAtIndexPath");
    
}

- (void)downLoadData
{
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *postDic = @{@"tid":self.tid,
                                  @"polloptionid":self.pollid
                                  };
        request.urlString = url_VoteOptionDetail;
        request.parameters = postDic;
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hideAnimated:YES];
        BOOL haveAuther = [ResponseMessage autherityJudgeResponseObject:responseObject refuseBlock:^(NSString *message) {
            [UIAlertController alertTitle:nil message:message controller:self doneText:@"知道了" cancelText:nil doneHandle:^{
                [self.navigationController popViewControllerAnimated:YES];
            } cancelHandle:nil];
            [self.HUD hideAnimated:YES];
        }];
        if (!haveAuther) {
            return;
        }
        if ([DataCheck isValidArray:[[[responseObject objectForKey:@"Variables"] objectForKey:@"viewvote"] objectForKey:@"voterlist"]]) {
            self.dataSourceArr = [[[responseObject objectForKey:@"Variables"] objectForKey:@"viewvote"] objectForKey:@"voterlist"];
        }
        
        [self.tableView reloadData];
        [self emptyShow];
    } failed:^(NSError *error) {
        [self.HUD hideAnimated:YES];
        [self showServerError:error];
        [self emptyShow];
    }];
}
- (void)createImageViewArrayData:(NSMutableArray *)muttableArrData{
//    NSMutableArray *arrayValue = [[NSMutableArray alloc]init];
//    NSMutableArray *arrayImageValue = [[NSMutableArray alloc]init];
//    NSMutableArray *arrayImageValue2 = [[NSMutableArray alloc]init];
//    for (int i = 1; i<= muttableArrData.count; i++)
//    {
//        NSString *value = [NSString stringWithFormat:@"%d",i];
//        NSString *imageName = [NSString stringWithFormat:@"image%@.png",value];
//        UIImage *image = [UIImage imageNamed:imageName];
//        DLog(@"imageName == %@",imageName);
//        [arrayValue addObject:value];
//        [arrayImageValue addObject:image];
//    }
//    
//    for (int i = 6;i<=10; i++ )
//    {
//        NSString *value = [NSString stringWithFormat:@"%d",i];
//        NSString *imageName = [NSString stringWithFormat:@"image%@.png",value];
//        UIImage *image = [UIImage imageNamed:imageName];
//        [arrayImageValue2 addObject:image];
//        
//    }
//    _array = arrayValue;
//    _arrayImage = arrayImageValue;
//    _arrayImage =arrayImageValue2;
}

- (void)dealloc {
    DLog(@"ViewPollpotionViewController销毁了");
}


@end
