//
//  QXANaviView.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/9.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXANaviView.h"
#import "QXTrackCorrectManager.h"
#import "ZCKalmanAlgorithm.h"
#import "NSObject+LKDBHelper.h"
#import "QXFilterLocationManager.h"
@interface QXANaviView()<AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate,AMapNaviDriveDataRepresentable>{
}
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) ZCKalmanAlgorithm *kalmanFilter;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation QXANaviView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutNavi];
    }
    return self;
}

-(void)layoutNavi{
//    myKalManFilter = alloc_filter_velocity2d(1.0);
//    for (int i = 0; i < 100; ++i) {
//        update_velocity2d(myKalManFilter, i * 1, 0.0, 1.0);
//    }
    
    self.driveView = [[AMapNaviDriveView alloc]initWithFrame:self.bounds];
    [self.driveView setShowUIElements:NO];
    [self.driveView setCarImage:[QXConfiguration shareManager].driveNaviCarImage];
    //[self.driveView setMapZoomLevel:18.0];
    [self.driveView setCameraDegree:0.0];
    [self.driveView setShowUIElements:NO];
    self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
    self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    self.driveView.delegate = self;
    
    self.driveManager = [[AMapNaviDriveManager alloc] init];
    [self.driveManager setDelegate:self];
    [self.driveManager setEmulatorNaviSpeed:80];
    [self.driveManager addDataRepresentative:self.driveView];
    [self.driveManager addDataRepresentative:self];
    [self.driveManager setAllowsBackgroundLocationUpdates:YES];
    [self.driveManager setPausesLocationUpdatesAutomatically:NO];
    [self addSubview:self.driveView];
    self.queue = dispatch_queue_create([@"QXWebSocket.queue.com" UTF8String], DISPATCH_QUEUE_SERIAL);

}


-(void)setMapZoomLevel:(CGFloat)mapZoomLevel{
    [self.driveView setMapZoomLevel:mapZoomLevel];
}

-(void)setShowUIElements:(BOOL)showUIElements{
    [self.driveView setShowUIElements:showUIElements];
}

- (void)calculateDriveRouteWithStartPoints:(NSArray<AMapNaviPoint *> *)startPoints
                                 endPoints:(NSArray<AMapNaviPoint *> *)endPoints
                                 wayPoints:(nullable NSArray<AMapNaviPoint *> *)wayPoints
                           drivingStrategy:(AMapNaviDrivingStrategy)strategy{
   
   BOOL calcula =  [self.driveManager calculateDriveRouteWithStartPoints:startPoints
                                                endPoints:endPoints
                                                wayPoints:nil
                                          drivingStrategy:strategy];
    if (calcula) {
       
    }
    
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [self.driveManager startEmulatorNavi];
    //[self.driveManager startGPSNavi];

}
// 发生错误
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error {
    
    
}

// 路径规划失败
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    
    
}

// 开启导航
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"startNavi");
    
}

// 路线偏移重新规划路线
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager {
    
    [self.driveManager recalculateDriveRouteWithDrivingStrategy:AMapNaviDrivingStrategySingleDefault];
   
}


/**
 到达目的地
 */
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager {
    
    
}

/// 实时导航语音播报
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    

}


/// 是否播报导航语音
- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager {
    
    
    return NO;
}


/**
 *  导航信息更新回调
 *
 *  @param naviInfo 导航信息,参考 AMapNaviInfo 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo {
    //NSLog(@"AMapNaviInfo:%@", naviInfo);
   
 
}

- (void)simulationDriveWithAMapNaviLocation:(nullable AMapNaviLocation *)naviLocation {
    

}

-(void)filterLocation:(QXTraceLocation*) location{
    [[QXTrackCorrectManager shareManager] addTraceLocation:location filterJumpLocation:^(QXTraceLocation *filterLocation) {
        if (!self.kalmanFilter) {
            self.kalmanFilter = [[ZCKalmanAlgorithm alloc]initWithQXTraceLocation:filterLocation];
        }
        else{
            dispatch_async(self.queue, ^{
                
                QXTraceLocation* traceLocation =  [self.kalmanFilter processState:filterLocation];
                NSLog(@"after is %@",traceLocation);
                [QXTraceLocation insertToDB:traceLocation];
            });
            
        }
    }];
    
}

#pragma 导航巡航模式
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateCruiseInfo:(AMapNaviCruiseInfo *)cruiseInfo
{
    //NSLog(@"updateCruiseInfo:%@", cruiseInfo);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTrafficFacilities:(NSArray<AMapNaviTrafficFacilityInfo *> *)trafficFacilities
{
    //NSLog(@"updateTrafficFacilities:%@", trafficFacilities);
}

int i  = 0;
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation {
    //NSLog(@"AMapNaviLocation:%@", naviLocation);
    
   // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (naviLocation.coordinate.longitude >0 && naviLocation.coordinate.latitude >0) {
        QXTraceLocation *TraceLocation = [[QXTraceLocation alloc] init];
        TraceLocation.longitude = naviLocation.coordinate.longitude;
        TraceLocation.latitude = naviLocation.coordinate.latitude;
        //TraceLocation.currentDate = [NSDate date];
        TraceLocation.timestamp = naviLocation.timestamp;
        TraceLocation.speed = naviLocation.speed;
        TraceLocation.accuracy = naviLocation.accuracy;
        TraceLocation.altitude = naviLocation.altitude;
    

        if (naviLocation.coordinate.latitude >0) {
            
            [self filterLocation:TraceLocation];
//
        
        }
    }
       
         
//        ZCKalmanAlgorithm *manager = [ZCKalmanAlgorithm shareManagerWithQXTraceLocation:TraceLocation];
//        QXTraceLocation *tracelocation = [manager processState:TraceLocation];
        //NSLog(@"212121212");
        
    
        
////
////    //});
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (i<1) {
                i++;
                QXTraceLocation *TraceLocationJump = [[QXTraceLocation alloc] init];
                TraceLocationJump.longitude = naviLocation.coordinate.longitude+0.0160100;
                TraceLocationJump.latitude = naviLocation.coordinate.latitude-0.0160100;
                TraceLocationJump.currentDate = [NSDate date];
                TraceLocationJump.speed = naviLocation.speed+120;
                TraceLocationJump.accuracy = naviLocation.accuracy;
                TraceLocationJump.timestamp = naviLocation.timestamp;
                TraceLocationJump.speed = naviLocation.speed;
                TraceLocationJump.accuracy = naviLocation.accuracy;
                TraceLocationJump.altitude = naviLocation.altitude;
                [self filterLocation:TraceLocationJump];
            }

               
    });
////
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (i<3) {
//                i++;
//                QXTraceLocation *TraceLocationJump = [[QXTraceLocation alloc] init];
//                TraceLocationJump.longitude = naviLocation.coordinate.longitude+0.0160100;
//                TraceLocationJump.latitude = naviLocation.coordinate.latitude-0.0160100;
//                TraceLocationJump.currentDate = [NSDate date];
//                TraceLocationJump.speed = naviLocation.speed+120;
//                TraceLocationJump.accuracy = naviLocation.accuracy;
//                [[QXTrackCorrectManager shareManager] addTraceLocation:TraceLocationJump];
//            }
//
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (i<4) {
//            i++;
//            QXTraceLocation *TraceLocationJump = [[QXTraceLocation alloc] init];
//            TraceLocationJump.longitude = naviLocation.coordinate.longitude+0.0160100;
//            TraceLocationJump.latitude = naviLocation.coordinate.latitude-0.0160100;
//            TraceLocationJump.currentDate = [NSDate date];
//            TraceLocationJump.speed = naviLocation.speed+120;
//            TraceLocationJump.accuracy = naviLocation.accuracy;
//            [[QXTrackCorrectManager shareManager] addTraceLocation:TraceLocationJump];
//        }
//
//    });
//
}


@end
