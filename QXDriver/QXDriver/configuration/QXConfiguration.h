//
//  QXConfiguration.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/11.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const APIBASEURL = @"APIBASEURL";
static NSString *const kShowNetStatus_notConnect = @"连接已断开，当前可能收不到订单";
static NSString *const kShowNetStatus_reConnect = @"欢迎回来，正在连接服务器……";


/// 司机登录 type
typedef NS_ENUM(NSInteger , QXDRIVERLOGINTYPE){
    QXDRIVERLOGINTYPE_TAXI = 1,// 出租车
    QXDRIVERLOGINTYPE_SPECIALCAR = 2,// 专车
    QXDRIVERLOGINTYPE_CARPOOLING = 3,// 拼车
    QXDRIVERLOGINTYPE_EXPRESSCAR = 4,// 快车
    QXDRIVERLOGINTYPE_TRUNK = 5,// 货的
    QXDRIVERLOGINTYPE_RIDER = 6,//骑手
    QXDRIVERLOGINTYPE_MOVEING = 7,//搬家
    
};

///地图种类
typedef NS_ENUM(NSInteger , MAPTYPE){
    MAPTYPE_GAODE = 1,//高德
    MAPTYPE_GOOGLE = 2,//google
};

///项目类型
typedef NS_ENUM(NSInteger , PROJECTTYPE){
    PROJECTTYPE_YUEYUE = 0,//约约
    PROJECTTYPE_CHAOYUN = 1<<1,
    PROJECTTYPE_WEIBA = 1<<2,//微巴
    PROJECTTYPE_KUAIJIE = 1<<3,//快捷
    PROJECTTYPE_XUANXUAN = 1<<4,//轩轩
    PROJECTTYPE_WEIWEI = 1<<5,
    PROJECTTYPE_MAIOSHENG = 1<<6,//妙盛
    PROJECTTYPE_HUIYUE = 1<<7,//汇约
    PROJECTTYPE_A0 = 1<<8,
};

///订单详情消息类型
typedef NS_ENUM(NSInteger , ORDERMESSAGETYPE){
    ORDERMESSAGETYPE_BOOKING_ORDER = 2000,//预约单消息
    ORDERMESSAGETYPE_DELIVERY_ORDER = 2001,//派单消息
    ORDERMESSAGETYPE_PASSENGER_CANCEL_ORDER = 2002,//乘客取消订单
    ORDERMESSAGETYPE_PASSENGER_PAYOFF_ORDER = 2003,//乘客付费
    ORDERMESSAGETYPE_RESET_ORDER = 2004,//司机接收的订单被改派
    ORDERMESSAGETYPE_RECEIVEDRESET_ORDER = 2005,//司机接收被改派的订单
    ORDERMESSAGETYPE_PASSENGER_ASK_FOR_TRAVEL = 2006,//乘客申请形成
    ORDERMESSAGETYPE_MATCHINGSUCCESS_ORDER = 2007,//订单匹配成功
    ORDERMESSAGETYPE_CONSOLE_CANCEL_ORDER = 3004,//控制台取消订单
};

///系统消息
typedef NS_ENUM(NSInteger , SYSTEM_MESSAGETYPE){
    SYSTEM_MESSAGETYPE_COMMON = 6001,//系统消息
    
};

@interface QXConfiguration : NSObject

@property(nonatomic ,readonly,copy)NSString *httpPrefixUrl;
@property(nonatomic ,readonly,copy)NSString *wsPrefixUrl;
@property(nonatomic ,readonly,copy)NSString *monetaryUnit;
@property(nonatomic ,readonly,assign)QXDRIVERLOGINTYPE loginType;
@property(nonatomic ,readonly,assign)MAPTYPE mapType;
@property(nonatomic ,readonly,assign)PROJECTTYPE projectType;
@property(nonatomic ,readonly,copy)NSString *appid;
@property(nonatomic ,readonly,copy)NSString *ifMSCKey;
@property(nonatomic ,readonly,copy)NSString *shareQQAppId;
@property(nonatomic ,readonly,copy)NSString *shareQQAppKey;
@property(nonatomic ,readonly,copy)NSString *wechatAppId;
@property(nonatomic ,readonly,copy)NSString *wechatappSecret;
@property(nonatomic ,readonly,copy)NSString *appGDMapKey;
@property(nonatomic ,readonly,strong)UIImage *driveNaviCarImage;
+(instancetype)shareManager;

@end
