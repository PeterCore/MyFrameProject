//
//  ZCNavgtionbarOverlay.m
//  Maroc
//
//  Created by zhangchun on 2016/11/30.
//  Copyright © 2016年 zhangchun. All rights reserved.
//

#import "ZCNavgtionbarOverlay.h"

@implementation ZCNavgtionbarOverlay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame bottomLineColor:(UIColor *(^)(UIColor *))bottomLineColor{
    if (self == [super initWithFrame:frame]) {
        self.autoresizesSubviews = YES;
        self.bottomLineColorBlock = bottomLineColor;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    UIColor *color = nil;
    if (self.bottomLineColorBlock) {
        color = self.bottomLineColorBlock(color);
        if (color) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextMoveToPoint(context, 0, CGRectGetHeight(rect)-0.5);
            CGContextAddLineToPoint(context, self.bounds.size.width, CGRectGetHeight(rect)-0.5);
            CGContextStrokePath(context);
        }
        
    }
}




@end
