//
//  QXVerifyUserHandle.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXVerifyUserHandle : NSObject

/*
 * author zhangchun 
 *验证账号和身份证一致性
 */
+(void)verifyWithidCard:(nullable NSString*)idCard
             phone:(nullable NSString*)phone
             priority:(NetWorkManagerPriority)prority
             progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
              success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
              failure:(nullable void (^)( NSError * _Nonnull error))failure;

/*
 *获取手机验证码
 *
 */
+(void)sendVaildCodeWithidPhone:(nullable NSString*)phone
               priority:(NetWorkManagerPriority)prority
               progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
                failure:(nullable void (^)( NSError * _Nonnull error))failure;

/*
 *确认手机是否是本人在使用
 *
 */

+(void)verifyAccountWithVaildCode:(nullable NSString*)vaildCode
                  phone:(nullable NSString*)phone
               priority:(NetWorkManagerPriority)prority
               progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
                failure:(nullable void (^)( NSError * _Nonnull error))failure;

@end
