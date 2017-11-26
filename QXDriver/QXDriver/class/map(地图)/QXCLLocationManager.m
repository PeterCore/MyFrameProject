//
//  QXCLLocationManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/7.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXCLLocationManager.h"
#import <MAMapKit/MAGeometry.h>
@implementation QXLocationInfo

@end

static QXCLLocationManager *__manager = nil;

@interface QXCLLocationManager()<AMapLocationManagerDelegate , CLLocationManagerDelegate>
/**
 高德定位
 */
@property (nonatomic , strong) AMapLocationManager *amapLocationManager;

/**
 苹果手机自带定位
 */
@property (nonatomic , strong) CLLocationManager *coreLocationManager;
@property (nonatomic , strong) QXLocationInfo *locationInfo;
@property (nonatomic , copy)void (^locationblock)(QXLocationInfo *locationInfo);
@property (nonatomic , copy)void (^failuerblock)(NSString *errorMessage);
@end

@implementation QXCLLocationManager

+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}

-(instancetype)init{
    if(self = [super init]){
        if ([QXConfiguration shareManager].mapType == MAPTYPE_GAODE) {
            self.amapLocationManager = [[AMapLocationManager alloc] init];
            self.amapLocationManager.delegate = self;
            self.amapLocationManager.distanceFilter = 1.0; // 3米发起一次定位
            self.amapLocationManager.locationTimeout = 10.f;
            self.amapLocationManager.locatingWithReGeocode = YES; // 返回逆地理信息
            self.amapLocationManager.desiredAccuracy = 10;
        }
        else{
            self.coreLocationManager = [[CLLocationManager alloc] init];
            self.coreLocationManager.delegate = self;
            self.coreLocationManager.distanceFilter = 1;
            self.coreLocationManager.desiredAccuracy = 10;
        }
    }
    return self;
}

-(void)startLocationUpdating:(void(^)(QXLocationInfo *locationInfo))locationBlock
        failuerBlock:(void (^)(NSString *errorMessage))failuerBlock{
    
    self.locationblock = locationBlock;
    self.failuerblock = failuerBlock;
    
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        if ([QXConfiguration shareManager].mapType == MAPTYPE_GOOGLE) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                self.coreLocationManager.allowsBackgroundLocationUpdates = YES;
            }
            [self.coreLocationManager startUpdatingLocation];
            [self.coreLocationManager startUpdatingHeading];
            
        }else {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                self.amapLocationManager.allowsBackgroundLocationUpdates = YES;
            }
            self.amapLocationManager.allowsBackgroundLocationUpdates = YES;
            [self.amapLocationManager startUpdatingLocation]; // 开启持续定位
        }
    }
    else{
        if (self.failuerblock) {
            self.failuerblock(@"");
        }
    }
    
    
}

-(void)stopUpdating{
    if ([QXConfiguration shareManager].mapType == MAPTYPE_GOOGLE) {
        [self.coreLocationManager stopUpdatingLocation];
        [self.coreLocationManager stopUpdatingHeading];
    }
    else{
        [self.amapLocationManager stopUpdatingLocation];
    }
    
}


-(QXLocationInfo*)fetchCurrentLocation{
    return self.locationInfo;
}

/*
 *
 *注册地图
 */
-(void)registerCLLocationApiWithKey:(NSString *)key{
    
    [AMapServices sharedServices].apiKey = key;
    [self startLocationUpdating:nil failuerBlock:nil];

}


#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    
    
    if (self.locationInfo == nil) {
        self.locationInfo = [[QXLocationInfo alloc] init];
        self.locationInfo.userLocation = location;
    }
    
    MAMapPoint startPoint  = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.locationInfo.userLocation.coordinate.latitude , self.locationInfo.userLocation.coordinate.longitude));
    MAMapPoint endPoint  = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude , location.coordinate.longitude));
    
    self.locationInfo.distance = self.locationInfo.distance + MAMetersBetweenMapPoints(startPoint,endPoint);
    self.locationInfo.speed = location.speed;
    self.locationInfo.altitude = location.altitude;
    self.locationInfo.userLocation = location;
    if (reGeocode){
        if (self.locationblock) {
            self.locationblock(self.locationInfo);
        }
    }
    else{
        if (self.failuerblock) {
            self.failuerblock(@"");
        }
    }
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    
    self.locationInfo = nil;
    [self.amapLocationManager startUpdatingLocation]; // 开启持续定位
   
}




@end
