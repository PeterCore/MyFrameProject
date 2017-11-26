//
//  NSDictionary+QXUtils.m
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//
//

#import "NSDictionary+QXUtils.h"
#import "NSArray+QXUtils.h"

@implementation NSDictionary (QXUtils)

/**
 *  生成JSON格式的字符串
 *  A JSON formatted string from the receiver.
 */
- (NSString *)JSONString {
    
    if (self.count > 0) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
#ifdef DEBUG
        NSAssert(!error, @"Error serializing dictionary %@. Error: %@", self, error);
#endif
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

/**
 *  移除所有NSNull对象
 *  Remove all null objects
 *
 *  @return Returns an dictionary of none null.
 */
- (NSDictionary *)removeNulls {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:self];
    
    // 遍历字典
    [replaced enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSNull class]]) {
            /**
             *  @brief  此处直接移除null，而不是替换为字符串
             *  替换成字符串可能导致程序闪退，原因：原本是要NSArray或者NSDictionary对象，我们替换成NSString对象，导致读取出错而闪退
             */
            [replaced removeObjectForKey:key];
            
        } else if ([obj isKindOfClass:[NSArray class]]) {
            
            id newObj = [obj removeNulls];
            [replaced setObject:newObj forKey:key];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            
            id newObj = [obj removeNulls];
            [replaced setObject:newObj forKey:key];
        }
    }];
    
    return replaced;
    
}

/**
 是否包含NSNull
 
 @return 判断参数是否包含NSNull
 */
- (BOOL)containsNSNull {
    
    for (id value in self.allValues) {
        if ([value isKindOfClass:[NSNull class]]) {
            return YES;
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            
            return [value containsNSNull];
        } else if ([value isKindOfClass:[NSArray class]]) {
            
            return [value containsNSNull];
        }
        
    }
    return NO;
}

@end
