//
//  QXBaseRequest.h
//  QXDriver
//
//  Created by zhangchun on 2017/10/31.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCBaseRequest.h"

@interface QXBaseRequest : ZCBaseRequest
@property(nonatomic,copy)NSString *appid;
@property(nonatomic,assign)NSTimeInterval noncestr;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *sign;
@end
