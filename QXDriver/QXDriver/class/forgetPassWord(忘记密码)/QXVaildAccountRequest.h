//
//  QXVaildAccountRequest.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/18.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCBaseRequest.h"

@interface QXVaildAccountRequest : ZCBaseRequest
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *identifyCode;
@end
