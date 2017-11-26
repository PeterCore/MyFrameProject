//
//  UIView+DrawRoundCorner.h
//  quchu
//
//  Created by zhangchun on 16/8/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DrawRoundCorner)
-(void)clipBounds:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
-(void)drawRect:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;

-(void)drawDash:(CGFloat)dashPattern
   spacePattern:(CGFloat)spacePattern
   cornerRadius:(CGFloat)cornerRadius
    borderWidth:(CGFloat)borderWidth
    borderColor:(UIColor*)borderColor;
@end
