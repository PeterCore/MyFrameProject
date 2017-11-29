//
//  QXTrackCorrectManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/13.
//  Copyright © 2017年 千夏. All rights reserved.
//
#import "NSObject+LKDBHelper.h"
#import "QXTrackCorrectManager.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAGeometry.h>
static CGFloat MaxSpeed = 22.0;
static CGFloat MinSpeed = 1.0;

typedef void(^filterJumpLocationBlock)(QXTraceLocation *filterLocation);


@implementation QXTraceLocation

-(NSString*)description{
    
    return [NSString stringWithFormat:@"lat is %.8lf ,lon is %.8lf",self.latitude,self.longitude];
    
}

@end

@interface QXTrackCorrectManager(){
    dispatch_queue_t _queue;
    NSInteger _wCount;
}
@property(nonatomic,strong,readwrite)NSMutableArray *traceLocations;
@property(nonatomic,strong)NSMutableArray *w1TraceLocations;
@property(nonatomic,strong)NSMutableArray *w2TraceLocations;
@property(nonatomic,strong)QXTraceLocation *w1TraceLocation;//权重点
@property(nonatomic,strong)QXTraceLocation *w2TraceLocation;//权重点
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,strong)NSLock *filterLock;
@property(nonatomic,copy)filterJumpLocationBlock filterJumpLocationBlock;
@end

@implementation QXTrackCorrectManager

static QXTrackCorrectManager *__manager = nil;

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}

-(instancetype)init{
    if (self = [super init]) {
        if (!_queue) {
            _queue = dispatch_queue_create([@"QXTraceLocation.queue.com" UTF8String], DISPATCH_QUEUE_SERIAL);

        }
        self.filterLock = [[NSLock alloc]init];
    }
   return self;
}

-(void)addTraceLocation:(QXTraceLocation *)traceLocation filterJumpLocation:(void (^)(QXTraceLocation *))traceLocationBlock{
    
    if (traceLocation.latitude >0 && traceLocation.longitude>0) {
        //是否是第一个点
        //[QXTraceLocation insertToDB:traceLocation];
        if (!self.filterJumpLocationBlock) {
            self.filterJumpLocationBlock = traceLocationBlock;
        }
        NSInteger count = [QXTraceLocation rowCountWithWhere:nil];
        if (!count) {
            [self.traceLocations addObject:traceLocation];
            if (traceLocationBlock) {
                self.filterJumpLocationBlock(traceLocation);
            }
            //[QXTraceLocation insertToDB:traceLocation];
            self.w1TraceLocation = traceLocation;
            [self.w1TraceLocations addObject:self.w1TraceLocation];
            _wCount++;
        }
        else{
            [self __filterTraceWithTraceLocation:traceLocation];
        }
    }
  
}


+(SIGNALSTRENGTH)gpsStrengthWith:(double)accuracy{
    SIGNALSTRENGTH strength = SIGNALSTRENGTH_BEST;
    if (accuracy > 200) {
        strength = SIGNALSTRENGTH_BAD;
    }
    else if (accuracy<200&&accuracy>100){
        strength = SIGNALSTRENGTH_AVERAGER;
    }
    else if (accuracy<100&&accuracy>20){
        strength  = SIGNALSTRENGTH_BETTER;
    }
    else if(accuracy<20){
        strength = SIGNALSTRENGTH_BEST;
    }
    return strength;
}


-(void)removeALLTraceLocations{
    [self.traceLocations removeAllObjects];
    [LKDBHelper clearTableData:[QXTraceLocation class]];
}

-(void)lock{
    [self.filterLock lock];
}

-(void)unlock{
    [self.filterLock unlock];
}
#pragma mark ---- 过滤飘点或跳点
-(void)__filterTraceWithTraceLocation:(QXTraceLocation*)traceLocation{
    
    dispatch_async(_queue, ^{
        //QXTraceLocation *lastTraceLocation = self.traceLocations.lastObject;
        if(traceLocation.speed<MinSpeed){
            return ;
        }
        if (!self.w2TraceLocation) {
            long offsetTimeMils = [traceLocation.currentDate timeIntervalSince1970] - [self.w1TraceLocation.currentDate timeIntervalSince1970];
            long offsetSeconds = offsetTimeMils;
            MAMapPoint startPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.w1TraceLocation.latitude , self.w1TraceLocation.longitude));
            MAMapPoint endPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(traceLocation.latitude , traceLocation.longitude));
            float distance = MAMetersBetweenMapPoints(startPoint, endPoint);
            long maxDistance = offsetSeconds*MaxSpeed;
            if (distance > maxDistance) {
                self.w2TraceLocation = traceLocation;
                [self.w2TraceLocations addObject:self.w2TraceLocation];
            }
            else{
                traceLocation.distance = distance;
                [self.w1TraceLocations addObject:traceLocation];
                QXTraceLocation *w1temp = [[QXTraceLocation alloc] init];
                w1temp.latitude      = self.w1TraceLocation.latitude*.2+traceLocation.latitude*.8;
                w1temp.longitude     = self.w1TraceLocation.longitude*.2+traceLocation.longitude*.8;
                NSTimeInterval timeVal = [traceLocation.timestamp timeIntervalSince1970]*.8;
                w1temp.timestamp     = [NSDate dateWithTimeIntervalSince1970:timeVal];
                w1temp.currentDate   = traceLocation.currentDate;
                w1temp.speed         = traceLocation.speed;
                w1temp.accuracy      = traceLocation.accuracy;
                self.w1TraceLocation = w1temp;
                _wCount++;
                if(self.w1TraceLocations.count > 3){
                    
                    for (QXTraceLocation *traceLocation in self.w1TraceLocations) {
                        
                        [self lock];
                        if (self.filterJumpLocationBlock) {
                            
                            
                            self.filterJumpLocationBlock(traceLocation);
                        }
                        [self unlock];
                        //[QXTraceLocation insertToDB:traceLocation];
                    }
                    
                    [self.traceLocations addObjectsFromArray:self.w1TraceLocations];
                    [self.w1TraceLocations removeAllObjects];
                }
                else{
                    
                }
                
            }
        }
#pragma mark ---- w2TraceLocation is not null
        else{
            long offsetTimeMils = [traceLocation.currentDate timeIntervalSince1970] - [self.w2TraceLocation.currentDate timeIntervalSince1970];
            long offsetSeconds = offsetTimeMils;
            MAMapPoint startPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.w2TraceLocation.latitude , self.w2TraceLocation.longitude));
            MAMapPoint endPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(traceLocation.latitude , traceLocation.longitude));
            float distance = MAMetersBetweenMapPoints(startPoint, endPoint);
            long maxDistance = offsetSeconds*16;
            NSLog(@"distance is %.2f/n",distance);
            if (distance > maxDistance) {
                [self.w2TraceLocations removeAllObjects];
                self.w2TraceLocation = traceLocation;
                [self.w2TraceLocations addObject:self.w2TraceLocation];
            }
            else{
                traceLocation.distance = distance;
                [self.w2TraceLocations addObject:traceLocation];//稳定后的点
                QXTraceLocation *w2temp = [[QXTraceLocation alloc] init];
                w2temp.latitude      = self.w2TraceLocation.latitude*.2+traceLocation.latitude*.8;
                w2temp.longitude     = self.w2TraceLocation.longitude*.2+traceLocation.longitude*.8;
                NSTimeInterval timeVal = [traceLocation.timestamp timeIntervalSince1970]*.8;
                w2temp.timestamp     = [NSDate dateWithTimeIntervalSince1970:timeVal];
                w2temp.currentDate   = traceLocation.currentDate;
                w2temp.speed         = traceLocation.speed;
                w2temp.accuracy      = traceLocation.accuracy;
                self.w2TraceLocation = w2temp;
                
                if (self.w2TraceLocations.count > 4) {
                    if (_wCount > 4) {
                        for (QXTraceLocation *traceLocation in self.w1TraceLocations) {
                            [self lock];
                            if (self.filterJumpLocationBlock) {
                                self.filterJumpLocationBlock(traceLocation);
                            }
                            [self unlock];
                            //[QXTraceLocation insertToDB:traceLocation];
                        }
                        [self.traceLocations addObjectsFromArray:self.w1TraceLocations];
                   
                    } else {
                        [self.w1TraceLocations removeAllObjects];;
                    }
                    for (QXTraceLocation *traceLocation in self.w2TraceLocations) {
                        [self lock];
                        if (self.filterJumpLocationBlock) {
                            self.filterJumpLocationBlock(traceLocation);
                        }
                        [self unlock];
                        //[QXTraceLocation insertToDB:traceLocation];
                    }
                    [self.traceLocations addObjectsFromArray:self.w2TraceLocations];
                    [self.w2TraceLocations removeAllObjects];
                    self.w1TraceLocation = self.w2TraceLocation;
                    self.w2TraceLocation = NULL;
                }
              
               
            }
           
        }
        
    });
}

//计算角度
+ (double)calculateCourseFromMapPoint:(MAMapPoint)p1 to:(MAMapPoint)p2
{
    MAMapPoint dp = MAMapPointMake(p2.x - p1.x, p1.y - p2.y);
    
    if (dp.y == 0)
        {
        return dp.x < 0? 270.f:0.f;
        }
    
    double dir = atan(dp.x/dp.y) * 180.f / M_PI;
    
    if (dp.y > 0){
        if (dp.x < 0){
            dir = dir + 360.f;
        }
        
        }else{
              dir = dir + 180.f;
    }
    
    return dir;
}
//计算
+ (CLLocationDirection)fixNewDirection:(CLLocationDirection)newDir basedOnOldDirection:(CLLocationDirection)oldDir
{
    //the gap between newDir and oldDir would not exceed 180.f degrees
    CLLocationDirection turn = newDir - oldDir;
    if(turn > 180.f){
        return newDir - 360.f;
    }
    else if (turn < -180.f){
        return newDir + 360.f;
    }
    else
    {
         return newDir;
    }
}




-(NSMutableArray*)w2TraceLocations{
    if (!_w2TraceLocations) {
        _w2TraceLocations = [NSMutableArray array];
    }
    return _w2TraceLocations;
}


-(NSMutableArray*)w1TraceLocations{
    if (!_w1TraceLocations) {
        _w1TraceLocations = [NSMutableArray array];
    }
    return _w1TraceLocations;
}


-(NSMutableArray*)traceLocations{
    if (!_traceLocations) {
        _traceLocations = [NSMutableArray array];
    }
    return _traceLocations;
}

@end
