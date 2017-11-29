//
//  QXMapView.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/6.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAPolylineRenderer.h>
@interface QXAMapView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
-(void)addAnnotationsWithOriginCoordinateAnddestCoordinate:(CLLocationCoordinate2D)origin
                                       dest:(CLLocationCoordinate2D)dest;

@end
