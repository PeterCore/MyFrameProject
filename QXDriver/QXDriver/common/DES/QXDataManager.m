//
//  QXDataManager.m
//  Pods
//
//  Created by Qianxia on 2016/12/31.
//
//

#import "QXDataManager.h"
#import "DES.h"
#import "AESCipher.h"
//#import <Realm/Realm.h>

static id manager;

@interface QXDataManager ()


@end

@implementation QXDataManager

/**
 Returns the singleton instance of this class.
 */
+ (instancetype)manager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializationData];
    }
    return self;
}

/**
 保存对象到NSUserDefaults中
 
 @param value NSObject值
 @param key key
 */
+ (void)saveValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:[QXDataManager base64AndDESEncodedObject:[NSString stringWithFormat:@"%@",value]] forKey:key];
}

/**
 从NSUserDefaults中获取值

 @param key key description
 @return value many be nil
 */
+ (id)getValueForKey:(NSString *)key {
    return [QXDataManager base64AndDESDecodedObject:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
}


/**
 从NSUserDefaults中移除

 @param key key description
 */
+ (void)removeValueForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

/**
 初始化数据
 */
- (void)initializationData {
    
}



/**
 获取 base64AndDES 加密之后的字符串
 
 @param NSString 需要加密的字符串
 @return 加密过的字符串
 */
+ (NSString *)base64AndDESEncodedObject: (NSString *)encodedString {
    if (encodedString.length == 0) {
        return nil;
    }
    
    return [DES encryptUseDES:encodedString key:@"QXSummerSoftDESConfigurationKey"];
}



/**
 获取 base64AndDES 解密之后的字符串
 
 @param decodedString 需要解密的字符串
 @return 解密后的字符串
 */
+ (NSString *)base64AndDESDecodedObject: (NSString *)decodedString {
    if (decodedString.length == 0) {
        return nil;
    }
    
    return [DES decryptUseDES:decodedString key:@"QXSummerSoftDESConfigurationKey"];
}


/**
 随机生成字符串
 
 @param count 需要多少位字符串
 @return 随机字符串
 */
+ (NSString *)getSomeCharactersOfRandom:(NSInteger)count {
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < count; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}



/**
 生成 AES 加密之后的文本
 
 @param content 需要加密的内容
 @return 加密后的文本
 */
+ (NSString *)getEncodeAESStringWithContent: (NSString *)content {
    
    if (content.length == 0) {
        return  nil;
    }
    NSString *key1 = @"AESCipher1234567";
    NSString *key2 = @"YYcx1289qazRan@!";
    NSString *aesOne = [AESCipher encryptAES:content key:key1];
    NSString *eightRandomChar1 = [self getSomeCharactersOfRandom:8];
    NSString *eightRandomChar2 = [self getSomeCharactersOfRandom:8];
    NSString *resultString1 = [NSString stringWithFormat:@"%@%@%@", eightRandomChar1, aesOne, eightRandomChar2];
    NSString *resultString2 = [AESCipher encryptAES:resultString1 key:key2];
    
    if ([resultString2 rangeOfString:@"+"].location != NSNotFound) {
        resultString2 = [resultString2 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    }
    if ([resultString2 rangeOfString:@"/"].location != NSNotFound) {
        resultString2 = [resultString2 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    }
    return resultString2;
}



@end
