//
//  CollectionTool.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/13.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "CollectionTool.h"

@implementation CollectionTool
+ (instancetype)shareInstance {
    static CollectionTool *collectionTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionTool = [[CollectionTool alloc] init];
    });
    return collectionTool;
}

- (void)collectionForum:(id)getDic andPostdic:(id)postDic success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_CollectionForum;
        request.methodType = JTMethodTypePOST;
        request.getParam = getDic;
        request.parameters = postDic;
    } success:^(id responseObject, JTLoadType type) {
        if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"] isEqualToString:@"favorite_do_success"]) {
            success();
        } else if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"] isEqualToString:@"favorite_repeat"]) {
            [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
            success();
        }
        else {
            [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD showInfo:@"收藏失败"];
        if (failure) {
            failure(error);
        }
    }];
}

// 新的取消收藏
- (void)deleCollection:(id)getDic andPostdic:(id)postDic success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_unCollection;
        request.methodType = JTMethodTypePOST;
        request.getParam = getDic;
        request.parameters = postDic;
    } success:^(id responseObject, JTLoadType type) {
        NSLog(@"%@",responseObject);
        
        if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"] isEqualToString:@"do_success"])
        {
            success();
        } else
        {
            [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD showInfo:@"取消收藏失败"];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)collectionThread:(id)getDic andPostdic:(id)postDic success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_CollectionThread;
        request.methodType = JTMethodTypePOST;
        request.getParam = getDic;
        request.parameters = postDic;
    } success:^(id responseObject, JTLoadType type) {
        if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messageval"] isEqualToString:@"favorite_do_success"]) {
            success?success():nil;
        } else {
            [MBProgressHUD showInfo:[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"]];
        }
    } failed:^(NSError *error) {
        [MBProgressHUD showInfo:@"收藏失败"];
        if (failure) {
            failure(error);
        }
    }];
}


@end
