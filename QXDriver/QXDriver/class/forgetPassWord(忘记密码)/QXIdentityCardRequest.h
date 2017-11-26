//
//  QXIdentityCardRequest.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCBaseRequest.h"

@interface QXIdentityCardRequest : ZCBaseRequest
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *idcard;
@end
