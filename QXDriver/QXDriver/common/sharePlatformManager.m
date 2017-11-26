//
//  sharePlatformManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/6.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "sharePlatformManager.h"
#import "QXConfiguration.h"
@implementation sharePlatformManager


+(void)registerSharePlatform{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformSubTypeQQFriend), // QQ好友
                                        @(SSDKPlatformSubTypeQZone), // QQ空间
                                        @(SSDKPlatformSubTypeWechatTimeline), // 微信朋友圈
                                        @(SSDKPlatformSubTypeWechatSession) // 微信好友
                                        ] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType) {
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
                                                    
                                                default:
                                                    break;
                                            }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case SSDKPlatformTypeQQ: //QQ平台, appid 回调需要用的的十六进制转化结果41ef9345, urlschemes: QQ41ef9345
                
                [appInfo SSDKSetupQQByAppId:[QXConfiguration shareManager].shareQQAppId appKey:[QXConfiguration shareManager].shareQQAppKey authType:SSDKAuthTypeBoth useTIM:NO];
                break;
            case SSDKPlatformTypeWechat:
                
                [appInfo SSDKSetupWeChatByAppId:[QXConfiguration shareManager].wechatAppId appSecret:[QXConfiguration shareManager].wechatappSecret];
                break;
            default:
                break;
        }
        
    }];
}

+(NSDictionary*)configuerWithDiffPlatforms:(NSString*)PlatformName dictionary:(NSDictionary*)params{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    
    NSString *iconName = @"";
    
    UIImage *icon = [UIImage imageNamed:iconName];
    NSArray* imageArray = [NSArray arrayWithObject:icon];
    
    NSString *titleStr = @"";
    NSString *contentStr = @"";
    NSString *urlStr = @"";
    if (params != nil) {
        
        titleStr = params[@"linkTitle"];
        contentStr = params[@"linkContent"];
        urlStr = params[@"linkUrl"];
    }
    
    [shareParams SSDKSetupShareParamsByText:contentStr
                                     images:imageArray
                                        url:[NSURL URLWithString:urlStr]
                                      title:titleStr
                                       type:SSDKContentTypeWebPage];
    
    return shareParams;
    
}


+(void)sharePlatformWithSSDKPlatformType:(SSDKPlatformType)formType
                              parameters:(NSDictionary*)paramters
                         complateHandler:(void(^)(SSDKResponseState state))stateBlock
{
    switch (formType) {
        case SSDKPlatformTypeWechat:
        {
            if (![WXApi isWXAppInstalled]) {
                return;
              }
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline:
        {
            if (![WXApi isWXAppInstalled]) {
                return;
            }
        }
        
            break;
        case SSDKPlatformTypeQQ:
        {
            if (![TencentOAuth iphoneQQInstalled]) {
                return;
            }
        }
        
            break;
        case SSDKPlatformSubTypeQZone:
        {
            if (![TencentOAuth iphoneQQInstalled]) {
                return;
            }
        }
            break;
     
        default:
            break;
    }
    
    
    
    [ShareSDK share:formType parameters:[paramters mutableCopy] onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (stateBlock) {
            stateBlock(state);
        }
        
        
    }];
}

@end
