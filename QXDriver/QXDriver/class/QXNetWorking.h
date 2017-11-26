//
//  QXNetWorking.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCHttpRequestManager.h"
#import "QXBaseRequest.h"
@interface QXNetWorking : NSObject
+(void)qx_startHttpRequest:(nullable QXBaseRequest*)request
               priority:(NetWorkManagerPriority)prority
               progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
                failure:(nullable void (^)( NSError * _Nonnull error))failure;
@end
