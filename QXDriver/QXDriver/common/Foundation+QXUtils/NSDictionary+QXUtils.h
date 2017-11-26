//
//  NSDictionary+QXUtils.h
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QXUtils)

/**
 *  生成JSON格式的字符串
 *  A JSON formatted string from the receiver.
 */
@property (copy, nonatomic, readonly) NSString *JSONString;

/**
 *  移除所有NSNull对象
 *  Remove all null objects
 *
 *  @return Returns an dictionary of none null.
 */
- (NSDictionary *)removeNulls;

/**
 是否包含NSNull
 
 @return 判断参数是否包含NSNull
 */
- (BOOL)containsNSNull;

@end
