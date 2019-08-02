//
//  LoginController.h
//  DiscuzMobile
//
//  Created by HB on 17/1/10.
//  Copyright © 2017年 com.comzenz-service. All rights reserved.
//

#import "CountRootController.h"

typedef void(^RefreshBlock)(void);

@interface LoginController : CountRootController<UITextFieldDelegate>
@end
