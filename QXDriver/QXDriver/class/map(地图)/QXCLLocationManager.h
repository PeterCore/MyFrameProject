//
//  QXCLLocationManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/7.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapServices.h>
#import <GoogleMaps/GoogleMaps.h>


NS_ASSUME_NONNULL_BEGIN

@interface QXLocationInfo : NSObject
@property (nonatomic , strong) CLLocation *userLocation; // 经纬度坐标
@property (nonatomic , copy) NSString *formattedAddress; // 全称 例如:福建省厦门市思明区塔埔路靠近中国民生银行(厦门观音山支行)
@property (nonatomic , copy) NSString *country; // 国家 例如: 中国
@property (nonatomic , copy) NSString *province; // 省份 例如: 福建省
@property (nonatomic , copy) NSString *city; // 城市 例如: 厦门市
@property (nonatomic , copy) NSString *district; // 区域 例如: 思明区
@property (nonatomic , copy) NSString *citycode; // 城市区号(电话开头:0592) 例如: 0592
@property (nonatomic , copy) NSString *adcode; // 城市邮编 例如: 350203
@property (nonatomic , copy) NSString *street; // 街道 例如: 塔埔路
@property (nonatomic , copy) NSString *number; // 街道号 例如: 165号
@property (nonatomic , copy) NSString *POIName; // 兴趣点名称 (也就是定位地址:标志性地点)
@property (nonatomic , copy) NSString *AOIName; // 一般为null
@property(nonatomic , assign) double altitude; // 海拔高度
@property(nonatomic , assign) double speed; // 瞬时行驶速度
@property(nonatomic , assign) double distance;
@end

@class QXLocationInfo;
@interface QXCLLocationManager : NSObject


+(instancetype)shareManager;
-(void)registerGDCLLocationApiWithKey:(NSString*)key;
-(void)registerGGCLLocationApiWithKey:(NSString*)serviceKey;
-(void)startLocationUpdating:(void(^)(QXLocationInfo *locationInfo))locationBlock
        failuerBlock:(void(^)(NSString *errorMessage))failuerBlock;
-(void)stopUpdating;

-(QXLocationInfo*)fetchCurrentLocation;
@end
NS_ASSUME_NONNULL_END
