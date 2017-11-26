//
//  SVProgressHUD+HUB.h
//  designer
//
//  Created by zhangchun on 15/11/26.
//  Copyright © 2015年 zhangchun. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (HUB)
+(void)showLoadingView:(NSString*)tipString;
+(void)showSuccessView:(NSString*)tipString;
+(void)showErrorView:(NSString*)tipString;
+(void)showWarnView:(NSString*)tipString;
+(void)showHintView:(NSString *)tipString;
@end
