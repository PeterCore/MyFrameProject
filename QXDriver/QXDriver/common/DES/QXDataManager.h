//
//  QXDataManager.h
//  Pods
//
//  Created by Qianxia on 2016/12/31.
//
//

#import <Foundation/Foundation.h>

@protocol QXDataManagerDelegate <NSObject>

@property (strong, nonatomic) NSDictionary *dataDictionary;

+ (id)modelWithDataDictionary:(NSDictionary *)dataDictionary;

@end

@interface QXDataManager : NSObject

/**
 保存对象到NSUserDefaults中

 @param value NSObject值
 @param key key
 */
+ (void)saveValue:(id)value forKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key;
+ (void)removeValueForKey:(NSString *)key;


/**
 Returns the singleton instance of this class.
 */
+ (instancetype)manager;



/**
 获取 base64AndDES 加密之后的字符串
 
 @param NSString 需要加密的字符串
 @return 加密过的字符串
 */
+ (NSString *)base64AndDESEncodedObject: (NSString *)encodedString;


/**
 获取 base64AndDES 解密之后的字符串
 
 @param decodedString 需要解密的字符串
 @return 解密后的字符串
 */
+ (NSString *)base64AndDESDecodedObject: (NSString *)decodedString;



/**
 登录加密

 @param content content description
 @return return value description
 */
+ (NSString *)getEncodeAESStringWithContent: (NSString *)content;

@end
