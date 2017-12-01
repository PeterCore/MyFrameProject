//
//  QXLoginRequest.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXLoginRequest.h"

@implementation QXLoginRequest


-(NSString*)url{
    return @"api/v1/driver/login/login.yueyue";
}

-(NSString*)requestCenter{
    return APIBASEURL;
}

-(HTTPRequestMethod)requestMethod{
    return POSTMethod;
}

-(ApplicationType)applicationType{
    return ApplicationType_FORM;
}

@end



@implementation QXLoginResponse
@end

@implementation QXLoginResponseData

@end




