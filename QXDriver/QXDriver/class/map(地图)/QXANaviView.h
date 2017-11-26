//
//  QXANaviView.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/9.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface QXANaviView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
- (void)calculateDriveRouteWithStartPoints:(NSArray<AMapNaviPoint *> *)startPoints
                                 endPoints:(NSArray<AMapNaviPoint *> *)endPoints
                                 wayPoints:(nullable NSArray<AMapNaviPoint *> *)wayPoints
                           drivingStrategy:(AMapNaviDrivingStrategy)strategy;
-(void)setMapZoomLevel:(CGFloat)mapZoomLevel;
-(void)setShowUIElements:(BOOL)showUIElements;

NS_ASSUME_NONNULL_END
@end
