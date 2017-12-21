//
//  NavigtionTestViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "NavigtionTestViewController.h"

@interface NavigtionTestViewController ()
@property(nonatomic,strong)QXLocationInfo *mylocationinfo;
@end

@implementation NavigtionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    @weakify(self);


    [[QXCLLocationManager shareManager] startLocationUpdating:^(QXLocationInfo * locationInfo) {
        @strongify(self);
        if (!self.mylocationinfo) {
            self.mylocationinfo = locationInfo;
            [[QXCLLocationManager shareManager] stopUpdating];
            CLLocationCoordinate2D orgin = CLLocationCoordinate2DMake(locationInfo.userLocation.coordinate.latitude, locationInfo.userLocation.coordinate.longitude);
            CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(24.473523, 118.19098099999999);
            AMapGeoPoint *orignPoint = [AMapGeoPoint locationWithLatitude:orgin.latitude longitude:orgin.longitude];
            AMapGeoPoint *destPoint = [AMapGeoPoint locationWithLatitude:dest.latitude longitude:dest.longitude];
            QXANaviView *naviView = [[QXANaviView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:naviView];
            [naviView calculateDriveRouteWithStartPoints:@[orignPoint] endPoints:@[destPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        }


    } failuerBlock:^(NSString * _Nonnull errorMessage) {

    }];
}

-(void)fetchCurrentLocation:(QXLocationInfo *)locationInfo failuerError:(NSString *)failuerError{
    if (!self.mylocationinfo) {
        self.mylocationinfo = locationInfo;
        [[QXCLLocationManager shareManager] stopUpdating];
        CLLocationCoordinate2D orgin = CLLocationCoordinate2DMake(locationInfo.userLocation.coordinate.latitude, locationInfo.userLocation.coordinate.longitude);
        CLLocationCoordinate2D dest = CLLocationCoordinate2DMake(24.473523, 118.19098099999999);
        AMapGeoPoint *orignPoint = [AMapGeoPoint locationWithLatitude:orgin.latitude longitude:orgin.longitude];
        AMapGeoPoint *destPoint = [AMapGeoPoint locationWithLatitude:dest.latitude longitude:dest.longitude];
        QXANaviView *naviView = [[QXANaviView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:naviView];
        [naviView calculateDriveRouteWithStartPoints:@[orignPoint] endPoints:@[destPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[QXCLLocationManager shareManager] removeControllers:self];
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
