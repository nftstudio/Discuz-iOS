//
//  ForumInfoModel.m
//  DiscuzMobile
//
//  Created by HB on 16/12/21.
//  Copyright © 2016年 com.comzenz-service. All rights reserved.
//

#import "ForumInfoModel.h"

@implementation ForumInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        self.descrip = [value transformationStr];
    } else if ([key isEqualToString:@"id"]) {
        self.fid = value;
    } else if ([key isEqualToString:@"lastpost"]) {
        
        if ([DataCheck isValidDictionary:value]) {
            self.lastpost = [value objectForKey:@"dateline"];
        } else {
            [super setValue:value forKey:key];
        }
    } else if ([key isEqualToString:@"favorite"]) {
        self.favorited = value;
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"fid:%@，版块名：%@",_fid,_name];
}


@end
