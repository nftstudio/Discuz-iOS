//
//  UploadAttachModel.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/26.
//  Copyright © 2018年 com.comzenz-service. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WSImageModel;

@interface UploadAttachModel : NSObject

@property (nonatomic, strong) NSMutableArray <NSString *> *aidArray;
@property (nonatomic, strong) NSMutableArray <WSImageModel*> *imageModelArray;
@property (nonatomic, strong) NSMutableArray *photosArray;

@end
