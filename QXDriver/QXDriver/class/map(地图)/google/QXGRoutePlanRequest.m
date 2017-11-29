//
//  QXGRoutePlanRequest.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/28.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXGRoutePlanRequest.h"

@implementation QXGRoutePlanRequest

-(NSString*)url{
    return @"https://maps.googleapis.com/maps/api/directions/json";
}

-(HTTPRequestMethod)requestMethod{
    return GETMethod;
}

-(ApplicationType)applicationType{
    return ApplicationType_FORM;
}

@end


@implementation QXGRouteResponse

+(NSDictionary*)mj_objectClassInArray{
    return @{
             @"geocoded_waypoints":@"QXGeocodeWayPointItem",
             @"routes"            :@"QXRouteItem"
             };
}
@end


@implementation QXGeocodeWayPointItem @end
@implementation QXRouteItem

+(NSDictionary*)mj_objectClassInArray{
    return @{
             @"legs":@"QXLegsItem",
             };
}

@end
@implementation QXBoundsItem          @end
@implementation QXLegsItem
+(NSDictionary*)mj_objectClassInArray{
    
    return @{
             @"steps":@"QXStepsItem",
             };
}
@end

@implementation QXStepsItem           @end
@implementation QXLocation            @end
