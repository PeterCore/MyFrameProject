//
//  QXVaildCodeRequest.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/18.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXVaildCodeRequest.h"

@implementation QXVaildCodeRequest

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSString*)url{
    return @"api/v1/driver/identifyCode/send.yueyue";
}

-(HTTPRequestMethod)requestMethod{
    return POSTMethod;
}

-(NSString*)requestCenter
{
    return APIBASEURL;
}
@end
