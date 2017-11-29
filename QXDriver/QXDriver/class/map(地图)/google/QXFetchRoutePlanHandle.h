//
//  QXFetchRoutePlanHandle.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/28.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXGRoutePlanRequest.h"
@interface QXFetchRoutePlanHandle : NSObject

+(void)fetchRoutePlan:(QXGRoutePlanRequest* _Nonnull)request
             priority:(NetWorkManagerPriority)prority
             progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
              success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
              failure:(nullable void (^)( NSError * _Nonnull error))failure;

@end
