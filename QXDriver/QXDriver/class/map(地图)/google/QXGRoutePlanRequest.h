//
//  QXGRoutePlanRequest.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/28.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCBaseRequest.h"

@interface QXGRoutePlanRequest : ZCBaseRequest
@property(nonatomic,copy)NSString *origin;
@property(nonatomic,copy)NSString *destination;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *mode;
@end

@interface QXGRouteResponse : NSObject
@property(nonatomic,strong)NSArray *geocoded_waypoints;
@property(nonatomic,strong)NSArray *routes;
@property(nonatomic,strong)NSString *status;
@end

@interface QXGeocodeWayPointItem:NSObject
@property(nonatomic,strong)NSString *geocoder_status;
@property(nonatomic,strong)NSString *place_id;
@property(nonatomic,strong)NSArray *types;
@end

@class QXBoundsItem,QXLocation;
@interface QXRouteItem:NSObject
@property(nonatomic,strong)QXBoundsItem  *bounds;
@property(nonatomic,strong)NSString      *copyrights;
@property(nonatomic,strong)NSArray       *legs;
@property(nonatomic,strong)NSDictionary  *overview_polyline;
@property(nonatomic,strong)NSString      *summary;
@property(nonatomic,strong)NSArray       *warnings;
@property(nonatomic,strong)NSArray       *waypoint_order;
@end

@interface QXBoundsItem:NSObject
@property(nonatomic,strong)NSDictionary *northeast;
@property(nonatomic,strong)NSDictionary *southwest;
@end

@interface QXLegsItem:NSObject
@property(nonatomic,strong)NSDictionary *distance;
@property(nonatomic,strong)NSDictionary *duration;
@property(nonatomic,strong)NSString     *end_address;
@property(nonatomic,strong)NSDictionary *end_location;
@property(nonatomic,strong)NSString     *start_address;
@property(nonatomic,strong)NSDictionary *start_location;
@property(nonatomic,strong)NSArray      *steps;
@property(nonatomic,strong)NSArray      *traffic_speed_entry;
@property(nonatomic,strong)NSArray      *via_waypoint;
@end



@interface QXStepsItem:NSObject
@property(nonatomic,strong)NSDictionary *distance;
@property(nonatomic,strong)NSDictionary *duration;
@property(nonatomic,strong)QXLocation   *end_location;
@property(nonatomic,strong)QXLocation   *start_location;
@property(nonatomic,strong)NSDictionary *polyline;
@property(nonatomic,strong)NSString     *travel_mode;
@end

@interface QXLocation:NSObject
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@end










