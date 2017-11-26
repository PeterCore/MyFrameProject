//
//  QXNetWorking.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXNetWorking.h"
#import "NSString+QXUtils.h"
@implementation QXNetWorking




+(void)qx_startHttpRequest:(nullable QXBaseRequest*)request
                  priority:(NetWorkManagerPriority)prority
                  progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                   success:(nullable void (^)(NSURLResponse * _Nonnull response, id _Nullable responseObject))success
                   failure:(nullable void (^)( NSError * _Nonnull error))failure{
    
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *url = [[request urlWithSpace] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

    request.appid = [QXConfiguration shareManager].appid;
    request.noncestr = [[NSDate date] timeIntervalSince1970];
    if (QXUserDefaults.token) {
        request.token = QXUserDefaults.token;
    }
    NSDictionary *paramdict = [request bodyDictionary]?[request bodyDictionary]:[request toDictionary];
    NSString *sortString = [[self class] sortStringWithParameters:paramdict];
    NSString *sign = sortString.md5Hash.uppercaseString;
    if ([sign rangeOfString:@" "].location != NSNotFound) {
        sign = [sign stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    request.sign = sign;
    
    
    ZCHttpRequestManager *shareManager = [ZCHttpRequestManager shareManager];
    if (request.requestMethod == POSTMethod) {
        [shareManager POST:url parameters:request priority:prority progress:uploadProgress success:success failure:failure];
    }
    else if(request.requestMethod == GETMethod){
        [shareManager GET:url parameters:request priority:prority progress:uploadProgress success:success failure:failure];
    }
    
}


+ (NSString *)sortStringWithParameters:(NSDictionary *)parameters {

    if (!QXRequestKey) {
        if (!QXRequestKey) {
            NSAssert(NO, @"请先设置[ConnectionBaseManager setAppId:QXAppId]和[ConnectionBaseManager setRequestKey:QXRequestKey]");
        }
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    NSMutableString *sortString = [NSMutableString stringWithString:@""];
    
    // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
    for (id nestedKey in [parameters.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]]) {
        id nestedValue = parameters[nestedKey];
        if (nestedValue) {
            // 忽略空字符串
            if (![nestedValue description].isNonEmpty) {
                continue;
            }
            
            [sortString appendString:[NSString stringWithFormat:sortString.isNonEmpty ? @"&%@=%@" : @"%@=%@", [nestedKey description], [nestedValue description]]];
        }
    }
    
    [sortString appendFormat:@"&key=%@", QXRequestKey];
    
    return sortString;
}


@end
