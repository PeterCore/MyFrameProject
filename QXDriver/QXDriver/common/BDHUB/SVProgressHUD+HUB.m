//
//  SVProgressHUD+HUB.m
//  designer
//
//  Created by zhangchun on 15/11/26.
//  Copyright © 2015年 zhangchun. All rights reserved.
//


// RGB颜色转换（16进制->10进制）
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#import "SVProgressHUD+HUB.h"

@implementation SVProgressHUD (HUB)
+(void)showLoadingView:(NSString*)tipString
{
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:FEFont(14)];
    [SVProgressHUD setBackgroundColor:RGBA(0,0,0,.5)];

    //[SVProgressHUD showWithStatus:tipString maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:tipString];
}


+(void)showSuccessView:(NSString*)tipString{
    
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"checkmark2.0"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:FEFont(14)];
    [SVProgressHUD setBackgroundColor:RGBA(0,0,0,.5)];

   // [SVProgressHUD showSuccessWithStatus:tipString maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showInfoWithStatus:tipString];
    
}

+(void)showErrorView:(NSString*)tipString{

    //[SVProgressHUD setErrorImage:[UIImage imageNamed:@"close_icon"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:FEFont(14)];
    [SVProgressHUD setBackgroundColor:RGBA(0,0,0,.5)];
    //[SVProgressHUD showErrorWithStatus:tipString maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showInfoWithStatus:tipString];
    //[SVProgressHUD showInfoWithStatus:tipString];

    //[SVProgressHUD showErrorWithStatus:tipString];
    //[SVProgressHUD showImage:[UIImage imageNamed:@"close_icon"] status:tipString];
}

+(void)showWarnView:(NSString*)tipString{
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"warn_icon"]];

    [SVProgressHUD setForegroundColor:RGBA(0,0,0,.5)];
    [SVProgressHUD setFont:FEFont(14)];
    [SVProgressHUD setBackgroundColor:RGBA(0,0,0,.5)];
    //[SVProgressHUD showErrorWithStatus:tipString maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:tipString];

    
}

+(void)showHintView:(NSString *)tipString{
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"smile_icon"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:FEFont(14)];
    [SVProgressHUD setBackgroundColor:RGBA(0,0,0,.5)];

    [SVProgressHUD showInfoWithStatus:tipString];
}



@end
