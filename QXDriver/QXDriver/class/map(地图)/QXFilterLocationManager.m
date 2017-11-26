//
//  QXFilterLocationManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/24.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXFilterLocationManager.h"


@interface QXFilterLocationManager()
@property(nonatomic,strong)ZCKalmanAlgorithm *kalmanFilter;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation QXFilterLocationManager

static QXFilterLocationManager *__manager = nil;

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.queue = dispatch_queue_create([@"filterLocation.queue.com" UTF8String], DISPATCH_QUEUE_SERIAL);

    }
    return self;
}

-(void)filterLocationWithKalMan:(QXTraceLocation *)currentLocation filterLocation:(void (^)(QXTraceLocation *))filterLocationWithKalManBlock{
    if (!self.kalmanFilter) {
        self.kalmanFilter = [[ZCKalmanAlgorithm alloc]initWithQXTraceLocation:currentLocation];
        if (filterLocationWithKalManBlock) {
            filterLocationWithKalManBlock(currentLocation);
        }
    }
    [[QXTrackCorrectManager shareManager] addTraceLocation:currentLocation filterJumpLocation:^(QXTraceLocation *filterLocation) {
        
    
            dispatch_async(self.queue, ^{
            QXTraceLocation* traceLocation =  [self.kalmanFilter processState:filterLocation];
            if (filterLocationWithKalManBlock) {
            filterLocationWithKalManBlock(traceLocation);
            }

            });
        
    }];
    
    
    
}


@end
