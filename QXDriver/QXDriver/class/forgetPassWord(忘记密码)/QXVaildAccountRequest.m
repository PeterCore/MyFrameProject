//
//  QXVaildAccountRequest.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/18.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXVaildAccountRequest.h"

@implementation QXVaildAccountRequest

-(NSString*)url{
    return @"api/v1/driver/user/verifyCode.yueyue";
}

-(HTTPRequestMethod)requestMethod{
    return POSTMethod;
}

-(NSString*)requestCenter{
    return APIBASEURL;
}

@end
