//
//  QXIdentityCardRequest.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXIdentityCardRequest.h"

@implementation QXIdentityCardRequest

-(NSString*)url{
    return @"api/v1/driver/user/validate.yueyue";
}

-(HTTPRequestMethod)requestMethod{
    return POSTMethod;
}

-(NSString*)requestCenter
{
    return APIBASEURL;
}

@end
