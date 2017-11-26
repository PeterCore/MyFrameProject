//
//  NSData+QXUtils.h
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//
//

#import <Foundation/Foundation.h>

@interface NSData (QXUtils)

/**
 *  An NSString object that contains a hexadecimal representation of the receiver’s contents.
 */
@property (nonatomic, copy, readonly) NSString *hexString;

/**
 *  A SHA1 hash of the receiver, expressed as a 160 bit hex number.
 */
@property (nonatomic, copy, readonly) NSData *sha1Hash;

/**
 *  A MD5 hash of the receiver, expressed as a 128 bit hex number.
 */
@property (nonatomic, copy, readonly) NSData *md5Hash;

@end
