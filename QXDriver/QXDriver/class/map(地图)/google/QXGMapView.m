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
@property(nonatomic,strong)GMSMarker  *currentMarker;

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
        self.mapView.settings.compassButton = YES;
        [self.mapView.settings setAllGesturesEnabled:YES];
        [self addSubview:self.mapView];
    }
    return self;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
   /* [[QXCLLocationManager shareManager] startLocationUpdating:^(QXLocationInfo * _Nonnull locationInfo) {
        if (!self.currentMarker) {
            self.currentMarker = [GMSMarker markerWithPosition:locationInfo.userLocation.coordinate];
            self.currentMarker.infoWindowAnchor = CGPointMake(0.5, 0.5);
            self.currentMarker.icon = [UIImage imageNamed:@"car"];
            self.currentMarker.map = self.mapView;
        }
        else{
            self.currentMarker.position = locationInfo.userLocation.coordinate;
        }
        
    } failuerBlock:^(NSString * _Nonnull errorMessage) {
        
    }];*/
    
}

-(void)__updateCurrentPosition:(CLLocationCoordinate2D)coordinate2D{
    
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

-(void)updateCurrentLocation:(QXLocationInfo*)locationInfo{
    if (!self.currentMarker) {
        self.currentMarker = [GMSMarker markerWithPosition:locationInfo.userLocation.coordinate];
        self.currentMarker.infoWindowAnchor = CGPointMake(0.5, 0.5);
        UIImage *icon = [UIImage imageNamed:@"zhuanche_map_icon_car"];
        self.currentMarker.iconView = [[UIImageView alloc] initWithImage:icon];
        //self.currentMarker.tracksViewChanges = NO;
        //self.currentMarker.icon = icon;
        self.currentMarker.map = self.mapView;
    }
    else{
        self.currentMarker.position = locationInfo.userLocation.coordinate;
    }
    CLLocationDirection angle = -45;
    double radius = angle / 180.0 * M_PI;

    [UIView animateWithDuration:1.0 animations:^{
        self.currentMarker.iconView.transform = CGAffineTransformMakeRotation(-radius);

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
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:origin coordinate:dest];
    self.mapView.camera = [self.mapView cameraForBounds:bounds insets:UIEdgeInsetsMake(50, 50, 230, 50)];
    
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
