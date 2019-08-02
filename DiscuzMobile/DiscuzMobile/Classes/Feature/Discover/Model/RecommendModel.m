//
//  RecommendModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/9/7.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel


+ (NSArray *)setRecommendData:(id)responseObject {
    NSMutableArray *hotArr = [NSMutableArray array];
    
    if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"recommonthread_list"]]) {
        
        NSMutableDictionary *gropDic = [NSMutableDictionary dictionary];
        if ([DataCheck isValidDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"groupiconid"]]) {
            gropDic = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"groupiconid"]];
        }
        
        NSArray *recommonthread_list = [[responseObject objectForKey:@"Variables"] objectForKey:@"recommonthread_list"];
        
        for (NSDictionary *dic in recommonthread_list) {
            RecommendModel *home = [[RecommendModel alloc] init];
            [home setValuesForKeysWithDictionary:dic];
            if ([DataCheck isValidDictionary:gropDic]) {
                home.grouptitle = [gropDic objectForKey:home.authorid];
            }
            
            [hotArr addObject:home];
        }
        
    }
    return hotArr;
}

@end
