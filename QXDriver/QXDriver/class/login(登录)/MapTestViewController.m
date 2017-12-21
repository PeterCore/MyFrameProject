//
//  MapTestViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "MapTestViewController.h"
#import "QXAMapView.h"
#import "QXGMapView.h"
#import "QXCLLocationManager.h"

@interface MapTestViewController ()
@property(nonatomic,strong)QXLocationInfo *mylocationinfo;
@property(nonatomic,strong)QXAMapView *gmap;
@end

@implementation MapTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.gmap = [[QXAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.gmap];
    
}

-(void)fetchCurrentLocation:(QXLocationInfo *)locationInfo failuerError:(NSString *)failuerError{
    if (!self.mylocationinfo) {
        self.mylocationinfo = locationInfo;
        [[QXCLLocationManager shareManager] stopUpdating];
//        CLLocationCoordinate2D orgin = CLLocationCoordinate2DMake(locationInfo.userLocation.coordinate.latitude, locationInfo.userLocation.coordinate.longitude);
//        CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(24.473523, 118.19098099999999);
//        [self.gmap addAnnotationsWithOriginCoordinateAnddestCoordinate:orgin dest:dest];
//        //[self.gmap updateCurrentLocation:locationInfo];

        //            AMapGeoPoint *orignPoint = [AMapGeoPoint locationWithLatitude:orgin.latitude longitude:orgin.longitude];
        //            AMapGeoPoint *destPoint = [AMapGeoPoint locationWithLatitude:dest.latitude longitude:dest.longitude];
        //            QXANaviView *naviView = [[QXANaviView alloc] initWithFrame:self.view.bounds];
        //            [self.view addSubview:naviView];
        //            [naviView calculateDriveRouteWithStartPoints:@[orignPoint] endPoints:@[destPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    }
    else{
        //[self.gmap updateCurrentLocation:locationInfo];
    }
}
-(void)dealloc{
    [[QXCLLocationManager shareManager]removeControllers:self];
}

-(void)navigationleftClick:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
