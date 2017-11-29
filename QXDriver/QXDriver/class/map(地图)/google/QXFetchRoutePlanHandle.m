//
//  QXFetchRoutePlanHandle.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/28.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXFetchRoutePlanHandle.h"

@implementation QXFetchRoutePlanHandle

+(void)fetchRoutePlan:(QXGRoutePlanRequest* _Nonnull)request
             priority:(NetWorkManagerPriority)prority
             progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
              success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
              failure:(nullable void (^)( NSError * _Nonnull error))failure{
    
    ZCHttpRequestManager *shareManager = [ZCHttpRequestManager shareManager];
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *url = [[request urlWithSpace] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    [shareManager GET:url parameters:request priority:prority progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        QXGRouteResponse *routeResponse = [QXGRouteResponse mj_objectWithKeyValues:responseObject];
        if (success) {
            success(response,routeResponse);
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

@end
