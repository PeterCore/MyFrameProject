//
//  ZCKalmanAlgorithm.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/20.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCKalmanAlgorithm.h"
#import "ZCMatrix.h"
#import "QXTrackCorrectManager.h"
static CGFloat stateMDimension = 6;
static CGFloat stateNDimension = 1;


@interface ZCKalmanAlgorithm()
@property(nonatomic,strong)ZCMatrix *xk1;
@property(nonatomic,strong)ZCMatrix *Pk1;
@property(nonatomic,strong)ZCMatrix *A;
@property(nonatomic,strong)ZCMatrix *Qt;
@property(nonatomic,strong)ZCMatrix *R;
@property(nonatomic,strong)ZCMatrix *zt;
@property(nonatomic,strong)NSDate *previousMeasureTime;
@property(nonatomic,strong)QXTraceLocation *previousLocation;
@property(nonatomic,strong)NSLock *mlock;
@property(nonatomic,assign)double rValue;
@property(nonatomic,assign)double sigma;
@end

@implementation ZCKalmanAlgorithm
@synthesize rValue = _rValue , sigma = _sigma;

static ZCKalmanAlgorithm *__manager = nil;
+(instancetype)shareManagerWithQXTraceLocation:(QXTraceLocation*)location{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] initWithQXTraceLocation:location];
    });
    return __manager;
}

-(void)lock{
    [self.mlock lock];
}

-(void)unlock{
    [self.mlock unlock];
}

-(instancetype)initWithQXTraceLocation:(QXTraceLocation*)location
{
    if (self = [super init]) {
        self.mlock = [[NSLock alloc] init];
        self.previousLocation =  [[QXTraceLocation alloc] init];
        self.previousMeasureTime = [[NSDate alloc] init];
        self.xk1 = [ZCMatrix initWithDimensions:stateMDimension colunms:stateNDimension];
        self.Pk1 = [ZCMatrix initWithDimensions:stateMDimension colunms:stateMDimension];
        self.A   = [ZCMatrix initWithDimensions:stateMDimension colunms:stateMDimension];
        self.Qt  = [ZCMatrix initWithDimensions:stateMDimension colunms:stateMDimension];
        self.R   = [ZCMatrix initWithDimensions:stateMDimension colunms:stateMDimension];
        self.zt  = [ZCMatrix initWithDimensions:stateMDimension colunms:stateNDimension];
        [self initKalman:location];
    }
    return self;
}


-(void)__confiugerStrengthWith:(QXTraceLocation*)location{
    SIGNALSTRENGTH strength = [QXTrackCorrectManager gpsStrengthWith:location.accuracy];
    switch (strength) {
        case SIGNALSTRENGTH_BEST:
            _sigma = 3.0725;
            _rValue = 1.0;
            break;
        case SIGNALSTRENGTH_BETTER:
            _sigma = 3.0625;
            _rValue = 1.3;
            break;
        case SIGNALSTRENGTH_AVERAGER:
            _sigma = 0.0725;
            _rValue = 18.0;
            break;
        case SIGNALSTRENGTH_BAD:
            _sigma = 0.0625;
            _rValue = 29.0;
            break;
        default:
            break;
    }
}

-(void)initKalman:(QXTraceLocation*)location{
    
    [self __confiugerStrengthWith:location];
    
    self.previousMeasureTime = location.timestamp;
    self.previousLocation = location;
    self.xk1 = [ZCMatrix rows:stateMDimension columns:stateNDimension values:
                location.latitude,
                0.0,
                location.longitude,
                0.0,
                location.altitude,
                0.0
                ];
    
    self.Pk1 = [ZCMatrix rows:stateMDimension columns:stateMDimension values:
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0
                ];
    
    self.A   =  [ZCMatrix rows:stateMDimension columns:stateMDimension values:
                 1.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                 0.0, 1.0, 0.0, 0.0, 0.0, 0.0,
                 0.0, 0.0, 1.0, 0.0, 0.0, 0.0,
                 0.0, 0.0, 0.0, 1.0, 0.0, 0.0,
                 0.0, 0.0, 0.0, 0.0, 1.0, 0.0,
                 0.0, 0.0, 0.0, 0.0, 0.0, 1.0
                 ];
    
    
    self.R  =  [ZCMatrix rows:stateMDimension columns:stateMDimension values:
                _rValue, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, _rValue, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, _rValue, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, _rValue, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, _rValue, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0, _rValue
                ];

}

-(void)resetKalmanWithQXTraceLocation:(QXTraceLocation*) location{
     [self initKalman:location];
}

-(QXTraceLocation*)processState:(QXTraceLocation*)currentLocation{
    [self __confiugerStrengthWith:currentLocation];

    NSDate *newMeasureTime = currentLocation.timestamp;
    double newMeasureTimeSeconds = [newMeasureTime timeIntervalSince1970];
    double lastMeasureTimeSeconds = [self.previousMeasureTime timeIntervalSince1970];
    double timeInterVal = newMeasureTimeSeconds - lastMeasureTimeSeconds;
   
    self.A   =  [ZCMatrix rows:stateMDimension columns:stateMDimension values:
                 1.0, timeInterVal, 0.0, 0.0, 0.0 ,0.0,
                 0.0, 1.0, 0.0, 0.0, 0.0, 0.0,
                 0.0, 0.0, 1.0, timeInterVal, 0.0, 0.0,
                 0.0, 0.0, 0.0, 1.0, 0.0, 0.0,
                 0.0, 0.0, 0.0, 0.0, 1.0, timeInterVal,
                 0.0, 0.0, 0.0, 0.0, 1.0, 1.0
                 ];
    
    double part1 = _sigma*(pow(timeInterVal, 4)/4.0);
    double part2 = _sigma*(pow(timeInterVal, 3)/2.0);
    double part3 = _sigma*(pow(timeInterVal, 2));
    
    self.Qt  = [ZCMatrix rows:stateMDimension columns:stateMDimension values:
                part1, part2, 0.0, 0.0, 0.0, 0.0,
                part2, part3, 0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, part1, part2, 0.0, 0.0,
                0.0, 0.0, part2, part3, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0, part1, part2,
                0.0, 0.0, 0.0, 0.0, part2, part3
                ];
    
    double velocityXComponent = (self.previousLocation.latitude - currentLocation.latitude)/timeInterVal;
    double velocityYComponent = (self.previousLocation.longitude - currentLocation.longitude)/timeInterVal;
    double velocityZComponent = (self.previousLocation.altitude - currentLocation.altitude)/timeInterVal;
    
    self.zt = [ZCMatrix rows:stateMDimension columns:stateNDimension values:
                currentLocation.latitude,
                velocityXComponent,
                currentLocation.longitude,
                velocityYComponent,
                currentLocation.altitude,
                velocityZComponent
                ];
    
    self.previousLocation = currentLocation;
    self.previousMeasureTime = newMeasureTime;
    return [self kalmanFilter];
}


-(QXTraceLocation*)kalmanFilter{
    
    ZCMatrix *xk  = [self.A multiplyBy:self.xk1];
    ZCMatrix *Pk  = [[[self.A multiplyBy:self.Pk1] multiplyByTransposeOf:self.A] add:self.Qt];
    
    ZCMatrix *tmp = [Pk add:self.R];
    ZCMatrix *Kt  = [Pk multiplyBy:[tmp invertmatrix]];
    ZCMatrix *xt  = [xk add:[Kt multiplyBy:[self.zt sub:xk]]];
    
    ZCMatrix *Pt  = [[[ZCMatrix getIdentity:stateMDimension] sub:Kt] multiplyBy:Pk];
    
    
    self.xk1 = xt;
    self.Pk1 = Pt;
    

    double lat = self.xk1.data[0];
    double lon = self.xk1.data[2];
    double altitude = self.xk1.data[4];
    
    QXTraceLocation *currentlocation = [[QXTraceLocation alloc]init];
    currentlocation.latitude = lat;
    currentlocation.longitude = lon;
    currentlocation.altitude = altitude;
    currentlocation.accuracy = self.previousLocation.accuracy;
    currentlocation.timestamp = self.previousMeasureTime;
    return currentlocation;
    
}



@end
