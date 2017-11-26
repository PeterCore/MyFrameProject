//
//  NSMutableAttributedString+Helper.h
//  FamilyEdu
//
//  Created by zhangchun on 2017/5/17.
//  Copyright © 2017年 ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Helper)
+ (NSMutableAttributedString*)attributedWithSubstring:(NSString*)str textColor:(UIColor*)textColor font:(CGFloat)fontSize;

@end
