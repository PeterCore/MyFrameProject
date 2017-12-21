//
//  QXConfiguration.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/11.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXConfiguration.h"

/// 司机类型
typedef enum : NSUInteger {
    // 如果服务端变动,这里的返回的真实值需要向服务端查询,从新对照
    DriverTypeTaxi = 1, // 出租车         (登录type = 1 , 登录返回的真是type = 1)
    DriverTypeSpecialCar = 2, // 专车     (登录type = 2 , 登录返回的真是type = 2)
    DriverTypeCarPooling = 3, // 拼车     (登录type = 3 , 登录返回的真是type = 3)
    DriverTypeExpressCar = 4, // 快车     (登录type = 2 , 登录返回的真是type = 4)
    DriverTypeCargoTaxi = 5, // 货的      (登录type = 2 , 登录返回的真是type = 5)
    DriverTypeRider = 6, // 骑手          (登录type = 2 , 登录返回的真是type = 6)
    DriverTypeHouseMoving = 7 // 搬家     (登录type = 2 , 登录返回的真是type = 7)
} DriverType;

@interface QXConfiguration()
@property(nonatomic ,readwrite,copy)NSString *httpPrefixUrl;
@property(nonatomic ,readwrite,copy)NSString *wsPrefixUrl;
@property(nonatomic ,readwrite,copy)NSString *monetaryUnit;
@property(nonatomic ,readwrite,copy)NSString *appid;
@property(nonatomic ,readwrite,copy)NSString *ifMSCKey;
@property(nonatomic ,readwrite,copy)NSString *shareQQAppId;
@property(nonatomic ,readwrite,copy)NSString *shareQQAppKey;
@property(nonatomic ,readwrite,copy)NSString *wechatAppId;
@property(nonatomic ,readwrite,copy)NSString *wechatappSecret;
@property(nonatomic ,readwrite,copy)NSString *appGDMapKey;
@property(nonatomic ,readwrite,copy)NSString *appGGMapKey;

@property(nonatomic ,readwrite,assign)QXDRIVERLOGINTYPE loginType;
@property(nonatomic ,readwrite,assign)MAPTYPE mapType;
@property(nonatomic ,readwrite,assign)PROJECTTYPE projectType;
@property(nonatomic ,readwrite,strong)UIImage *driveNaviCarImage;
@end

@implementation QXConfiguration

static QXConfiguration *configuration = nil;

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [[[self class] alloc] init];
    });
    return configuration;
}


-(instancetype)init{
    if (self = [super init]) {
        [self __configuration3rd];
    }
    return self;
}

/*
 *
 *
 *
 */

-(void)__configuration3rd{
 
#pragma mark ----约约
    self.monetaryUnit = @"元";
    self.mapType = MAPTYPE_GAODE;
    self.httpPrefixUrl = @"http://5000.gr2a2739.summersoft.ali-sh.goodrain.net:10080/";
    self.wsPrefixUrl = @"ws://gr46e996.summersoft.ali-sh-s1.goodrain.net:20630";
    self.loginType = QXDRIVERLOGINTYPE_SPECIALCAR;
    self.projectType = PROJECTTYPE_YUEYUE;
    self.appid = @"9dd58b6d5f64a22d00c3f6264f8ce597";
    self.ifMSCKey = @"587ecf57";
    self.shareQQAppId = @"1105679589";
    self.shareQQAppKey = @"YDGv2hsWfiacI5ZJ";
    self.wechatAppId = @"wx9f9f6543465f0030";
    self.wechatappSecret = @"7a3bbbb98cf3e2aadada45a0a8f391d1";
    self.appGDMapKey = @"a7c51c6c425d00ef2e1eed562ca6a8c3";
    self.appGGMapKey = @"AIzaSyBEN9SgD1J69MHQE5QHf_-3hTwRk4urtVo";
    self.driveNaviCarImage = [UIImage imageNamed:@"zhuanche_map_icon_car"];
}
@end
