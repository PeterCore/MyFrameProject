//
//  QXRoute.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/8.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXARoute.h"
@interface QXARoute()
@property(nonatomic,readwrite,strong)NSMutableArray *routePolylines;
@end
@implementation QXARoute
+(instancetype)naviRouteWithPath:(AMapPath*)path origin:(AMapGeoPoint*)origin dest:(AMapGeoPoint*)dest
{
    return [[self alloc] initWithRoutePath:path origin:origin dest:dest];
}

-(instancetype)initWithRoutePath:(AMapPath*)path origin:(AMapGeoPoint*)origin dest:(AMapGeoPoint*)dest
{
    if (self = [super init]) {
        @weakify(self);
        [path.steps enumerateObjectsUsingBlock:^(AMapStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            MAPolyline *polyline = [[self class] ploylineWithStep:obj];
            if (polyline) {
                [self.routePolylines addObject:polyline];
                if (idx > 0) {
                    [[self class] replenishPolylinesForPathWith:polyline
                                                  lastPolyline:[[self class] ploylineWithStep:[path.steps objectAtIndex:idx-1]]
                                                     Polylines:self.routePolylines];
                }
            }
        }];
        
        [[self class] replenishPolylinesForStartPoint:origin endPoint:dest Polylines:self.routePolylines];

    }
    return self;
}

/// 补充起点和终点对于路径的空隙
+ (void)replenishPolylinesForStartPoint:(AMapGeoPoint *)start
                               endPoint:(AMapGeoPoint *)end
                              Polylines:(NSMutableArray *)polylines
{
    if (polylines.count < 1){
        return;
    }
    
    MAPolyline *startDashPolyline = nil;
    MAPolyline *endDashPolyline = nil;
    if (start){
        CLLocationCoordinate2D startCoor1 = CLLocationCoordinate2DMake(start.latitude, start.longitude);
        CLLocationCoordinate2D endCoor1 = startCoor1;
        
        MAPolyline *naviPolyline = [polylines firstObject];
        MAPolyline *polyline = nil;
        polyline = (MAPolyline *)naviPolyline;
        if (polyline){
            [polyline getCoordinates:&endCoor1 range:NSMakeRange(0, 1)];
            startDashPolyline = [self replenishPolylineWithStart:startCoor1 end:endCoor1];
            
        }
        } // end start
    
    if (end)
        {
        CLLocationCoordinate2D startCoor2;
        CLLocationCoordinate2D endCoor2;
        
        MAPolyline *naviPolyline = [polylines lastObject];
        MAPolyline *polyline = nil;
        polyline = (MAPolyline *)naviPolyline;
        
        if (polyline){
            [polyline getCoordinates:&startCoor2 range:NSMakeRange(polyline.pointCount - 1, 1)];
            endCoor2 = CLLocationCoordinate2DMake(end.latitude, end.longitude);
            
            endDashPolyline = [self replenishPolylineWithStart:startCoor2 end:endCoor2];
            }
        } //end end
    
    if (startDashPolyline)
    {
        [polylines addObject:startDashPolyline];
    }
    if (endDashPolyline)
    {
        [polylines addObject:endDashPolyline];
    }
}


/*
 *根据路径多段数据 合成线段
 *
 */
+(MAPolyline*)ploylineWithStep:(AMapStep*)step{
    NSString *coordinateString = step.polyline;
    if (!coordinateString.length) {
        return nil;
    }
    NSUInteger count = 0;
    CLLocationCoordinate2D *coordinates = [[self class] coordinatesForString:coordinateString
                                                     coordinateCount:&count
                                                          parseToken:@";"];
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    free(coordinates), coordinates = NULL;
    return polyline;
}
/*
 *解析step 返回经纬度
 *
 */

+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}


+ (void)replenishPolylinesForPathWith:(MAPolyline *)stepPolyline
                         lastPolyline:(MAPolyline *)lastPolyline
                            Polylines:(NSMutableArray *)polylines
{
    CLLocationCoordinate2D startCoor;
    CLLocationCoordinate2D endCoor;
    
    [stepPolyline getCoordinates:&endCoor range:NSMakeRange(0, 1)];
    
    [lastPolyline getCoordinates:&startCoor range:NSMakeRange(lastPolyline.pointCount -1, 1)];
    
    
    if ((endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude )){
        MAPolyline *Polyline = [self replenishPolylineWithStart:startCoor end:endCoor];
        if (Polyline)
        {
            [polylines addObject:Polyline];
        }
    }
}


+ (MAPolyline *)replenishPolylineWithStart:(CLLocationCoordinate2D)startCoor end:(CLLocationCoordinate2D)endCoor
{
    if (!CLLocationCoordinate2DIsValid(startCoor) || !CLLocationCoordinate2DIsValid(endCoor)){
        return nil;
    }
    
    double distance = MAMetersBetweenMapPoints(MAMapPointForCoordinate(startCoor), MAMapPointForCoordinate(endCoor));
    MAPolyline *dashPolyline = nil;
    if (distance > 5){
        CLLocationCoordinate2D points[2];
        points[0] = startCoor;
        points[1] = endCoor;
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:points count:2];
        dashPolyline = polyline;
     }
    return dashPolyline;
}


-(NSMutableArray*)routePolylines{
    if (!_routePolylines) {
        _routePolylines = [NSMutableArray array];
    }
    return _routePolylines;
    
    
}

@end
