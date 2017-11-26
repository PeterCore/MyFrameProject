//
//  Macros.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/11.
//  Copyright © 2017年 千夏. All rights reserved.
//

#ifndef Macros_h
#define Macros_h


static NSString * const QXRequestKey = @"fffa2a879e62e198924a95dc150dc33823bd0bf7abd3a20fff605f297ae9333804699723a6219048";

#if defined(__cplusplus)
#define FE_EXPORT extern "C"
#else
#define FE_EXPORT extern
#endif


#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
// block
#define weakify(var) \
try {} @catch (...) {} \
__weak __typeof__(var) var ## _weak = var;

#define strongify(var) \
try {} @catch (...) {} \
__strong __typeof__(var) var = var ## _weak;

/*颜色值*/
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define HEXACOLOR(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]


#define FERGBColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define FERGBAColor(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
/** 图片赋值 */
#define FEImage(imageName) [UIImage imageNamed:imageName]
//设备宽
#define IPHONE_W [UIScreen mainScreen].bounds.size.width
//设备高
#define IPHONE_H [UIScreen mainScreen].bounds.size.height
/** 屏幕尺寸size */
#define IPHONE_SIZE  [[UIScreen mainScreen] bounds].size
/** 屏幕尺寸frame */
#define IPHONE_FRAME [[UIScreen mainScreen] bounds]

//判断当前系统版本 >= ver?
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IosVersionFloat  ([[UIDevice currentDevice] systemVersion].floatValue)

#define async_main_queue(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ })


//系统字体

#define CHINESE_FONT_NAME  @"PingFangHK-Light"
#define CHINESE_BOLD_FONT_NAME  @"PingFangHK-Semibold"
#define CHINESE_MEDIUM_NAME @"PingFangHK-Medium"
#define CHINESE_Regular_NAME @"PingFangHK-Regular"

#define appVersionStr [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kAppName       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
#define NSString_Not_Nil(string) string?string:@""

#define FORMAT(f, ...)  [NSString stringWithFormat:f, ## __VA_ARGS__]

#define FEMediumFont(x) (IosVersionFloat>=9.0)?[UIFont fontWithName:CHINESE_MEDIUM_NAME size:(x)]:[UIFont boldSystemFontOfSize:(x)]

#define FEFont(x) (IosVersionFloat>=9.0)?[UIFont fontWithName:CHINESE_Regular_NAME size:(x)]:[UIFont systemFontOfSize:(x)]

#define FELightFont(x) (IosVersionFloat>=9.0)?[UIFont fontWithName:CHINESE_FONT_NAME size:(x)]:[UIFont systemFontOfSize:(x)]

//判断当前系统版本 >= ver?
//#define IosVersion_MoreThanOrEqualTO(ver)       ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] != NSOrderedAscending)

#define FEBoldFont(x) [UIFont boldSystemFontOfSize:(x)]

#define CONTENTLABEL_COLOR HEXCOLOR(0x999999)
#define FEWordColor HEXCOLOR(0x333333)
#define FEOtherColor HEXCOLOR(0xa3a3a3)
#define FEWordTitleColor HEXCOLOR(0x666666)

#define BACKGGROUND HEXCOLOR(0xefefef)
#define MARKBACKGROUND HEXCOLOR(0xdbdbdb)

#define NavigationBarColor FERGBColor(78, 83, 122)
#define NavigationBarBackground [UIColor whiteColor]
#define kselectNavtionBarButtonColor FERGBColor(46, 172, 250)

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define PLACEHOLDER FEImage(@"placeHolder")


#endif /* Macros_h */
