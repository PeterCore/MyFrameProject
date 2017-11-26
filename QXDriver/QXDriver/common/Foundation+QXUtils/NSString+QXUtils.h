//
//  NSString+QXUtils.h
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (QXUtils)

/**
 *  YES if the string is not empty and the length is greater than zero
 *  当为YES, string不为nil, 并且length大于0
 */
@property (readonly, nonatomic) BOOL isNonEmpty;

/**
 *  URL编码
 */
@property (readonly, copy, nonatomic) NSString *encodedURLQuery;

/**
 *  Returns a SHA1 hash of the receiver, expressed as a 160 bit hex number.
 */
@property (nonatomic, copy, readonly) NSString *sha1Hash;

/**
 *  Returns a MD5 hash of the receiver, expressed as a 128 bit hex number.
 */
@property (nonatomic, copy, readonly) NSString *md5Hash;

/**
 *  Checks for an emoji character in the receiver.
 */
@property (nonatomic, readonly) BOOL containsEmoji;

/**
 *  验证是否可用密码字符串(数字/大写字母/小写字母)
 */
@property (nonatomic, readonly) BOOL isVerificationPasswordCharacter;

/**
 *  判断是否为纯数字
 */
@property (nonatomic, readonly) BOOL isNumber;

/**
 *  判断是否为浮点数
 */
@property (nonatomic, readonly) BOOL isPureFloat;


/**
 将百分比转化为浮点数
 */
@property (nonatomic, readonly) CGFloat percentStringToFloat;


/**
 将浮点数转化为百分比

 @param value e.g 0.75
 @return e.g 75%
 */
- (NSString *)percentStringWithFloat:(CGFloat)value;

/**
 *  @brief  格式话小数 四舍五入类型
 *
 *  @param format 格式例如 0.000 ，保留三位小数
 *  @param floatV 数字
 *
 */
+ (NSString *)decimalwithFormat:(NSString *)format floatValue:(CGFloat)value;

/**
 *  Create a Base-64 encoded NSString from the receiver's contents using the given options. By default, no line endings are inserted.
 *  If you specify one of the line length options (NSDataBase64Encoding64CharacterLineLength or NSDataBase64Encoding76CharacterLineLength)
 *  but don’t specify the kind of line ending to insert, the default line ending is Carriage Return + Line Feed.
 *
 *  @param options A mask that specifies options for Base-64 encoding the data. Possible values are given in “NSDataBase64EncodingOptions”.
 *
 *  @return A Base-64 encoded string.
 */
- (NSString *)base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options;

/**
 *  Create a Base-64, UTF-8 encoded NSData from the receiver's contents using the given options. By default, no line endings are inserted.
 *  If you specify one of the line length options (NSDataBase64Encoding64CharacterLineLength or NSDataBase64Encoding76CharacterLineLength)
 *  but don’t specify the kind of line ending insert, the default line ending is Carriage Return + Line Feed.
 *
 *  @param options A mask that specifies options for Base-64 encoding the data. Possible values are given in “NSDataBase64EncodingOptions”.
 *
 *  @return A Base-64, UTF-8 encoded data object.
 */
- (NSData *)base64EncodedDataWithOptions:(NSDataBase64EncodingOptions)options;

/**
 *  Returns a Foundation object from the receiver. The string must be formatted as valid JSON.
 *
 *  @param options  Options for reading the JSON data and creating the Foundation objects.
 *  @param outError If an error occurs, upon return contains an NSError object that describes the problem.
 *
 *  @return  A Foundation object from the JSON in the string as UTF8 encoded data, or nil if an error occurs.
 */
- (id)JSONObject:(NSJSONReadingOptions)options error:(NSError **)outError;


/**
 URL解码

 @return return value description
 */
- (NSString *)URLDecoding;

@end
