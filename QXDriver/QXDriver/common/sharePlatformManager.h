//
//  sharePlatformManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/6.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sharePlatformManager : NSObject


+(void)registerSharePlatform;
+(NSDictionary*)configuerWithDiffPlatforms:(NSString*)PlatformName dictionary:(NSDictionary*)params;
+(void)sharePlatformWithSSDKPlatformType:(SSDKPlatformType)formType
                              parameters:(NSDictionary*)paramters
                         complateHandler:(void(^)(SSDKResponseState state))stateBlock;
@end
