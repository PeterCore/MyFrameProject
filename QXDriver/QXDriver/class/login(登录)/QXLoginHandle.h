//
//  QXLoginHandle.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/14.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QXLoginRequest.h"


@interface QXLoginHandle : NSObject

+(void)loginWithPhone:(nullable NSString*)phone
             passWord:(nullable NSString*)passWord
             priority:(NetWorkManagerPriority)prority
             progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
              success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
              failure:(nullable void (^)( NSError * _Nonnull error))failure;

@end
