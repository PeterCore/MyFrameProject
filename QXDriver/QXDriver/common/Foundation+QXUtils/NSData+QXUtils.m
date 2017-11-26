//
//  NSData+QXUtils.m
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//
//

#import "NSData+QXUtils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (QXUtils)

- (NSString *)hexString {
    NSUInteger bytesCount = self.length;
    if (bytesCount) {
        static char const *kHexChars = "0123456789ABCDEF";
        const unsigned char *dataBuffer = self.bytes;
        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
        char *s = chars;
        for (unsigned i = 0; i < bytesCount; ++i) {
            *s++ = kHexChars[((*dataBuffer & 0xF0) >> 4)];
            *s++ = kHexChars[(*dataBuffer & 0x0F)];
            dataBuffer++;
        }
        *s = '\0';
        NSString *hexString = [NSString stringWithUTF8String:chars];
        free(chars);
        return hexString;
    }
    return @"";
}

- (NSData *)sha1Hash {
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    if (CC_SHA1(self.bytes, (CC_LONG)self.length, digest)) {
        return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    }
    return nil;
}

- (NSData *)md5Hash {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    if (CC_MD5(self.bytes, (CC_LONG)self.length, digest)) {
        return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    }
    return nil;
}



@end
