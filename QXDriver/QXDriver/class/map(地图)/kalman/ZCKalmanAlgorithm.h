//
//  ZCKalmanAlgorithm.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/20.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXTrackCorrectManager.h"

@interface ZCKalmanAlgorithm : NSObject

+(instancetype)shareManagerWithQXTraceLocation:(QXTraceLocation*)location;
-(instancetype)initWithQXTraceLocation:(QXTraceLocation*)location;
-(QXTraceLocation*)processState:(QXTraceLocation*)location;
-(void)resetKalmanWithQXTraceLocation:(QXTraceLocation*) location;
@end
