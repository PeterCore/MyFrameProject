//
//  QXVerifyUserHandle.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXVerifyUserHandle.h"
#import "QXIdentityCardRequest.h"
#import "QXVaildCodeRequest.h"
#import "QXVaildAccountRequest.h"
@implementation QXVerifyUserHandle

+(void)verifyWithidCard:(NSString *)idCard phone:(NSString *)phone priority:(NetWorkManagerPriority)prority progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLResponse * _Nonnull, id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure{
    
    QXIdentityCardRequest *request = [[QXIdentityCardRequest alloc] init];
    request.mobile = phone;
    request.idcard = idCard;
    [QXNetWorking qx_startHttpRequest:request priority:NetWorkManagerPriorityMedum progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        if(success){
            success(response,responseObject);
        };
        
    } failure:^(NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
        
    }];
    
}


+(void)sendVaildCodeWithidPhone:(nullable NSString*)phone
                       priority:(NetWorkManagerPriority)prority
                       progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                        success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
                        failure:(nullable void (^)( NSError * _Nonnull error))failure;
{
    QXVaildCodeRequest *request = [[QXVaildCodeRequest alloc] init];
    request.mobile = phone;
    [QXNetWorking qx_startHttpRequest:request priority:NetWorkManagerPriorityMedum progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        if(success){
            success(response,responseObject);
        };
        
    } failure:^(NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
        
    }];
}


+(void)verifyAccountWithVaildCode:(nullable NSString*)vaildCode
                            phone:(nullable NSString*)phone
                         priority:(NetWorkManagerPriority)prority
                         progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                          success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
                          failure:(nullable void (^)( NSError * _Nonnull error))failure{
    
    QXVaildAccountRequest *request = [[QXVaildAccountRequest alloc] init];
    request.identifyCode = vaildCode;
    request.mobile = phone;
    [QXNetWorking qx_startHttpRequest:request priority:NetWorkManagerPriorityMedum progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        if(success){
            success(response,responseObject);
        };
        
    } failure:^(NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
        
    }];
    
}

@end
