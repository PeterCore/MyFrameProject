//
//  QXFilterLocationManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/24.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCKalmanAlgorithm.h"
#import "QXTrackCorrectManager.h"

typedef void(^filterLocationWithKalManBlock)(QXTraceLocation *filterLocation);
@interface QXFilterLocationManager : NSObject

+(instancetype)shareManager;
-(void)filterLocationWithKalMan:(QXTraceLocation *)currentLocation  filterLocation:(void(^)(QXTraceLocation *filterLocation))filterLocationWithKalManBlock;

@end
