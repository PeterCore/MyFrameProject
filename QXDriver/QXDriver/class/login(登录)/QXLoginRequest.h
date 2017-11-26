//
//  QXLoginRequest.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCBaseRequest.h"


@interface QXLoginRequest : QXBaseRequest
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *deviceVersion;
@property(nonatomic,copy)NSString *appVersion;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger deviceType;
@property(nonatomic,copy)NSString *deviceToken;

@end

@class QXLoginResponseData;
@interface QXLoginResponse : QXBaseResponse
@property(nonatomic,strong)QXLoginResponseData *data;
@end

@interface QXLoginResponseData : NSObject
@property(nonatomic,copy)NSString *agentUuid;
@property(nonatomic,copy)NSString *appointTimeEnd;
@property(nonatomic,copy)NSString *appointTimeStart;
@property(nonatomic,copy)NSString *balance;
@property(nonatomic,copy)NSString *brandName;
@property(nonatomic,copy)NSString *carColor;
@property(nonatomic,copy)NSString *carLevelName;
@property(nonatomic,copy)NSString *companyUuid;
@property(nonatomic,assign)NSInteger canWishdraw;
@property(nonatomic,assign)NSInteger carLevelType;
@property(nonatomic,copy)NSString *currentAngle;
@property(nonatomic,copy)NSString *face;
@property(nonatomic,copy)NSString *inCome;
@property(nonatomic,assign)NSInteger isFirst;
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger orderCount;
@property(nonatomic,assign)NSInteger percent;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *plateNum;
@property(nonatomic,assign)NSInteger poundageMoney;
@property(nonatomic,copy)NSString *poundageTitle;
@property(nonatomic,assign)NSInteger poundageType;
@property(nonatomic,assign)NSInteger remindType;
@property(nonatomic,copy)NSString *responsibleMobile;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *serviceMileage;
@property(nonatomic,assign)NSInteger sex;
@property(nonatomic,assign)NSInteger shortName;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger withdrawalCash;
@property(nonatomic,copy)NSString *uuid;

@end

