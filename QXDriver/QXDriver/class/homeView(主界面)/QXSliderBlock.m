//
//  QXSliderBlock.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/22.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXSliderBlock.h"

@implementation QXSliderBlock


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, kselectNavtionBarButtonColor.CGColor);
    CGContextMoveToPoint(context, 20, rect.size.height-3);
    CGContextAddLineToPoint(context, self.bounds.size.width-20, rect.size.height-3);
    CGContextStrokePath(context);
}


@end
