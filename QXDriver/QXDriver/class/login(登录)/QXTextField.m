//
//  QXTextField.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/13.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXTextField.h"

@implementation QXTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, HEXCOLOR(0x333333).CGColor);//线条颜色
    CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect),CGRectGetMaxY(rect));
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1.0);
    CGContextStrokePath(context);
}

@end
