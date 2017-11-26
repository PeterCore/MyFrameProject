//
//  NSMutableAttributedString+Helper.m
//  FamilyEdu
//
//  Created by zhangchun on 2017/5/17.
//  Copyright © 2017年 ye. All rights reserved.
//

#import "NSMutableAttributedString+Helper.h"

@implementation NSMutableAttributedString (Helper)

/**
 *  返回导航栏标题特殊样式的字符串
 */
+ (NSMutableAttributedString*)attributedWithSubstring:(NSString*)str textColor:(UIColor*)textColor font:(CGFloat)fontSize
{
    
    if (str==nil) {
        return nil;
    }
    
    //创建数字的样式
    NSMutableAttributedString *arrtStr = [[NSMutableAttributedString alloc] initWithString:str];
    [arrtStr addAttributes:@{
                             NSFontAttributeName :  FEFont(fontSize),
                             NSForegroundColorAttributeName: textColor
                             } range:NSMakeRange(0, str.length)];
    
    return arrtStr;
    
}

@end
