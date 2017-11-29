//
//  QXMapView.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/6.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXAMapView.h"
#import "QXARoute.h"
#import "NSObject+LKDBHelper.h"
#import "QXTrackCorrectManager.h"
@interface QXAMapView()<MAMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapSearchAPI *searchApi;
@property(nonatomic,strong)AMapGeoPoint *orignPoint;
@property(nonatomic,strong)AMapGeoPoint *destPoint;
@end

@implementation QXAMapView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        if([NSThread isMainThread]){
            [self layoutMapView];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutMapView];
            });
        }
    }
    return self;
}

- (void)willRemoveSubview:(UIView *)subview;
{
    self.mapView.delegate = nil;
    self.mapView = nil;
}

-(void)layoutMapView{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.mapView.userInteractionEnabled = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.autoresizesSubviews = NO;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 16;
    self.mapView.maxZoomLevel = 18;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.mapView];
    [self test];
}

-(void)test{
    int _endIndexPath = 0;
    QXTraceLocation *_endLocation;
    //NSMutableArray *accuracy
    NSMutableArray *traceLocationAcc = [QXTraceLocation searchWithWhere:[NSString stringWithFormat:@"accuracy != %d",65]];
    NSMutableArray *traceLocations = [QXTraceLocation searchWithWhere:nil];
    NSMutableArray *lines = [NSMutableArray array];
    for (int i = _endIndexPath; i < traceLocations.count; i++) {
        QXTraceLocation *newlocation =  traceLocations[i];
        if (newlocation.latitude >0 && newlocation.longitude > 0) {
            
            if (!_endLocation) {
                _endLocation = newlocation;
            }
            CLLocationCoordinate2D newCLLocation =  CLLocationCoordinate2DMake(newlocation.latitude, newlocation.longitude);
            CLLocationCoordinate2D endCLLocation =  CLLocationCoordinate2DMake(_endLocation.latitude, _endLocation.longitude);
            MAMapPoint point1 = MAMapPointForCoordinate(newCLLocation);
            MAMapPoint point2 = MAMapPointForCoordinate(endCLLocation);
            
            //2.计算距离
            //CLLocationDistance newDistance = MAMetersBetweenMapPoints(point1,point2);
            //if (newDistance>10) {
            
            CLLocationCoordinate2D commonPolylineCoords[2];
            commonPolylineCoords[0] = newCLLocation;
            commonPolylineCoords[1] = endCLLocation;
//
             MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
//            [self.mapView addOverlay: commonPolyline];
            [lines addObject:commonPolyline];
            
            _endIndexPath = i;
            _endLocation = newlocation;
            //}
        }
        
    }
    [self.mapView addOverlays:lines];
}

/*
 *
 *起点终点标签
 */
-(void)addAnnotationsWithOriginCoordinateAnddestCoordinate:(CLLocationCoordinate2D)origin dest:(CLLocationCoordinate2D)dest{
    
    NSMutableArray *annotations = [NSMutableArray array];
    if (origin.latitude&&origin.longitude) {
        MAPointAnnotation *annotation_Origin = [[MAPointAnnotation alloc] init];
        annotation_Origin.title = @"起点";
        annotation_Origin.coordinate = origin;
        [annotations addObject:annotation_Origin];
    }
    if (dest.latitude&&dest.longitude){
        MAPointAnnotation *annotation_dest = [[MAPointAnnotation alloc] init];
        annotation_dest.title = @"终点";
        annotation_dest.coordinate = dest;
        [annotations addObject:annotation_dest];
    }
    if(annotations.count){
        [self.mapView addAnnotations:annotations];
    }
    
//    CLLocationDegrees minlat = MIN(origin.latitude, dest.latitude);
//    CLLocationDegrees maxlat = MAX(origin.latitude, dest.latitude);
//    CLLocationDegrees minlongitude = MIN(origin.longitude, dest.longitude);
//    CLLocationDegrees maxlongitude = MAX(origin.longitude, dest.longitude);
//    CLLocationCoordinate2D centCoor;
//    centCoor.latitude = (CLLocationDegrees)((minlat+maxlat) * 0.5f);
//    centCoor.longitude = (CLLocationDegrees)((minlongitude+maxlongitude) * 0.5f);
//    MACoordinateSpan span = MACoordinateSpanMake(maxlat-minlat, maxlongitude-maxlongitude);
//    MACoordinateRegion region = MACoordinateRegionMake(centCoor, span);
//    MAMapRect mapRect = MAMapRectForCoordinateRegion(region);
//    //[self.mapView setVisibleMapRect:mapRect animated:YES];
//    //[self.mapView setRegion:region];
    [self drivingRouteWithOriginCoordinateAnddestCoordinate:origin dest:dest];
    [self.mapView setZoomLevel:13];
    [self.mapView showAnnotations:annotations edgePadding:UIEdgeInsetsMake(80, 80, 230, 80) animated:YES];


}

/*
 * 规划速度最快路径
 *
 */
-(void)drivingRouteWithOriginCoordinateAnddestCoordinate:(CLLocationCoordinate2D)origin dest:(CLLocationCoordinate2D)dest{
    AMapDrivingRouteSearchRequest *naviRequest = [[AMapDrivingRouteSearchRequest alloc] init];
    naviRequest.requireExtension = YES;
    naviRequest.strategy = 0;
    AMapGeoPoint *orignPoint = [AMapGeoPoint locationWithLatitude:origin.latitude longitude:origin.longitude];
    naviRequest.origin = orignPoint;
    AMapGeoPoint *destPoint = [AMapGeoPoint locationWithLatitude:dest.latitude longitude:dest.longitude];
    naviRequest.destination = destPoint;
    self.orignPoint = orignPoint;
    self.destPoint =destPoint;
    if (!self.searchApi) {
        self.searchApi = [[AMapSearchAPI alloc] init];
        self.searchApi.delegate = self;
    }
    [self.searchApi AMapDrivingRouteSearch:naviRequest];
}


#pragma mark --- MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation;
{
     //给终点和起点 下标签
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"routePlanningCellIdentifier"];
        if (!poiAnnotationView){
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:@"routePlanningCellIdentifier"];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = [[annotation title] isEqualToString:@"起点"]?FEImage(@"public_pic_qidian"):FEImage(@"public_pic_zhongdian");
    
        return poiAnnotationView;
      }
     return nil;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"路线规划失败");
}

/*路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)return;
     AMapPath *nowRoute = response.route.paths.firstObject;
    if (response.count > 0){
        QXARoute *route = [QXARoute naviRouteWithPath:nowRoute origin:self.orignPoint dest:self.destPoint];
        [self.mapView addOverlays:route.routePolylines];
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = MAUserTrackingModeNone;
        self.mapView.showTraffic = NO;
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((MAPolyline *)overlay)];
    polylineRenderer.lineWidth   = 6;
    polylineRenderer.lineDash = NO;
    polylineRenderer.lineCapType = kMALineCapRound;
    polylineRenderer.lineJoinType = kMALineJoinRound;
    polylineRenderer.strokeColor = HEXCOLOR(0x3585ff);
    return polylineRenderer;
}


@end
