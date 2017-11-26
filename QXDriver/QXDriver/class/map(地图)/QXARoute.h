//
//  QXRoute.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/8.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAPolyline.h>

@interface QXARoute : NSObject
@property(nonatomic,readonly,strong)NSMutableArray *routePolylines;

+(instancetype)naviRouteWithPath:(AMapPath*)path origin:(AMapGeoPoint*)origin dest:(AMapGeoPoint*)dest;

@end
