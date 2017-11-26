//
//  QXTrackCorrectManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger , SIGNALSTRENGTH){
    SIGNALSTRENGTH_BEST = 1,
    SIGNALSTRENGTH_BETTER,
    SIGNALSTRENGTH_AVERAGER,
    SIGNALSTRENGTH_BAD,
    
};

/*
 *运动轨迹点
 *
 *
 */
@interface QXTraceLocation:NSObject
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;
@property(nonatomic,assign)double accuracy;
@property(nonatomic,assign)double distance;
@property(nonatomic,assign)double mileage;
@property(nonatomic,assign)double speed;
@property(nonatomic,assign)double direction;
@property(nonatomic,assign)double altitude;
@property(nonatomic,strong)NSDate *timestamp;
@property(nonatomic,strong)NSDate *currentDate;

@end


@interface QXTrackCorrectManager : NSObject
@property(nonatomic,readonly,strong)NSMutableArray *traceLocations;
+(instancetype)shareManager;
-(void)addTraceLocation:(QXTraceLocation*)traceLocation filterJumpLocation:(void(^)(QXTraceLocation *traceLocation))traceLocationBlock;
+(SIGNALSTRENGTH)gpsStrengthWith:(double)accuracy;
-(void)removeALLTraceLocations;
@end

