//
//  NSString+QXUtils.m
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//
//

#import "NSString+QXUtils.h"
#import "NSData+QXUtils.h"

@implementation NSString (QXUtils)

/**
 *  判断字符串不为空
 *
 *  @return 当为YES, string不为nil, 并且length大于0
 */
- (BOOL)isNonEmpty {
    
    BOOL isNonEmpty = ![self isEqual:[NSNull null]] && self.length > 0;
    
    return isNonEmpty;
}

/**
 *  对网址进行编码
 *
 */
- (NSString *)encodedURLQuery {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)sha1Hash {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data sha1Hash];
    return [hash hexString];
}

- (NSString *)md5Hash {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data md5Hash];
    return [hash hexString];
}

- (BOOL)containsEmoji {
    static dispatch_once_t once;
    static NSRegularExpression *regex;
    dispatch_once(&once, ^{
        NSError *error = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSParameterAssert(!error);
    });
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return numberOfMatches != 0;
}

/**
 *  @brief  验证是否可用密码(由数字/大写字母/小写字母)
 *
 *  @param str 要检验的字符串
 *
 */
- (BOOL)isVerificationPasswordCharacter {
    
    NSRange letterRang, numberRange;
    // 字母
    letterRang = [self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    numberRange = [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (letterRang.location == NSNotFound && numberRange.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isNumber {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (CGFloat)percentStringToFloat {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumber *number = [formatter numberFromString:self];
    
    return [number doubleValue];
}

/**
 将浮点数转化为百分比
 
 @param value e.g 0.75
 @return e.g 75%
 */
- (NSString *)percentStringWithFloat:(CGFloat)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    return [formatter stringFromNumber:@(value)];
}

/**
 *  @brief  格式话小数 四舍五入类型
 *
 *  @param format 格式例如 0.000 ，保留三位小数
 *  @param floatV 数字
 *
 */
+ (NSString *)decimalwithFormat:(NSString *)format floatValue:(CGFloat)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

- (NSString *)base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)options {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:options];
}

- (NSData *)base64EncodedDataWithOptions:(NSDataBase64EncodingOptions)options {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedDataWithOptions:options];
}

- (id)JSONObject:(NSJSONReadingOptions)options error:(NSError **)outError {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:options error:outError];
}

/**
 URL解码
 
 @return return value description
 */
- (NSString *)URLDecoding {
    NSMutableString *string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
