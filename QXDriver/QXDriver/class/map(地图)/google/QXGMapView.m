//
//  QXGMapView.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/28.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXGMapView.h"
#import "QXFetchRoutePlanHandle.h"
@interface QXGMapView()<GMSMapViewDelegate>
@property(nonatomic,strong)GMSMapView *mapView;

@end
@implementation QXGMapView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.mapView = [[GMSMapView alloc] initWithFrame:self.bounds];
        self.mapView.delegate = self;
        [self addSubview:self.mapView];
    }
    return self;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
}

-(void)addAnnotationsWithOriginCoordinateAnddestCoordinate:(CLLocationCoordinate2D)origin dest:(CLLocationCoordinate2D)dest{
    
    [self __setAnnotationWithLocation:origin dest:dest];
    [self __planRouteWithLocation:origin dest:dest coordinates:^(NSMutableArray *coordinates) {
        GMSMutablePath *path = [GMSMutablePath path];
        for (QXLocation *loaction in coordinates) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(loaction.lat, loaction.lng);
            [path addCoordinate:coordinate];
        }
        GMSPolyline *routeLine = [GMSPolyline polylineWithPath:path];
        routeLine.strokeWidth = 2.0f;
        routeLine.map =self.mapView;

    }];
    
}


-(void)__setAnnotationWithLocation:(CLLocationCoordinate2D)origin dest:(CLLocationCoordinate2D)dest {
    
    GMSMarker *originMark = [GMSMarker markerWithPosition:origin];
    originMark.infoWindowAnchor = CGPointMake(0.5, 0.5);
    originMark.icon = [UIImage imageNamed:@"default_navi_route_startpoint"];
    originMark.map = self.mapView;
    
    GMSMarker *destMark = [GMSMarker markerWithPosition:dest];
    destMark.infoWindowAnchor = CGPointMake(0.5, 0.5);
    destMark.icon = [UIImage imageNamed:@"default_navi_route_endpoint"];
    destMark.map = self.mapView;
    
    CLLocationCoordinate2D target = origin;
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:target zoom:13];
    
}

-(void)__planRouteWithLocation:(CLLocationCoordinate2D)origin
                          dest:(CLLocationCoordinate2D)dest
                   coordinates:(void(^)(NSMutableArray *coordinates))stepsBlock{
    NSString *originLocation = [NSString stringWithFormat:@"%.20f,%.20f",origin.latitude,origin.longitude];
    NSString *destLocation   = [NSString stringWithFormat:@"%.20f,%.20f",dest.latitude,dest.longitude];
    
    QXGRoutePlanRequest *request = [[QXGRoutePlanRequest alloc] init];
    request.origin = originLocation;
    request.destination = destLocation;
    request.mode = @"driving";
    request.key = [QXConfiguration shareManager].appGGMapKey;
    
    [QXFetchRoutePlanHandle fetchRoutePlan:request priority:NetWorkManagerPriorityLow progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            QXGRouteResponse *routeResponse = (QXGRouteResponse*)responseObject;
            if ([routeResponse.status isEqualToString:@"OK"]) {
                if (routeResponse.routes.count) {
                    QXRouteItem *routeItem = routeResponse.routes[0];
                    if (routeItem.legs.count) {
                        NSMutableArray *coordinates = [NSMutableArray array];
                        QXLegsItem *legItem = routeItem.legs[0];
                        [coordinates addObject:legItem.start_location];
                        for (QXStepsItem *item in legItem.steps) {
                            [coordinates addObject:item.start_location];
                            [coordinates addObject:item.end_location];
                        }
                        [coordinates addObject:legItem.end_location];
                        if (stepsBlock) {
                            stepsBlock(coordinates);
                        }
                    }
                }
            }
            else{
                
            }
        });
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



@end
