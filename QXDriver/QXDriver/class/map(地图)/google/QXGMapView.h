//
//  QXGMapView.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/28.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface QXGMapView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
-(void)addAnnotationsWithOriginCoordinateAnddestCoordinate:(CLLocationCoordinate2D)origin
                                                      dest:(CLLocationCoordinate2D)dest;
@end
