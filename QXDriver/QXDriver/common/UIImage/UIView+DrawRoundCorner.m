//
//  UIView+DrawRoundCorner.m
//  quchu
//
//  Created by zhangchun on 16/8/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIView+DrawRoundCorner.h"
#import <objc/runtime.h>

static const char kbindShapeLayer;

@interface UIView(ZCDrawRoundCorner)
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@end

@implementation UIView (DrawRoundCorner)

-(void)setShapeLayer:(CAShapeLayer *)shapeLayer{
    
    objc_setAssociatedObject(self, @selector(shapeLayer), shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(CAShapeLayer*)shapeLayer{
    CAShapeLayer *shapeLayer = objc_getAssociatedObject(self, @selector(shapeLayer));
    if (!shapeLayer) {
        shapeLayer = [[CAShapeLayer alloc]init];
    }
    return shapeLayer;
}

-(void)clipBounds:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds ;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    [self drawRect:cornerRadius borderWidth:borderWidth borderColor:borderColor];
}

-(void)drawRect:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor
{
   
    CGRect frame = self.bounds;
    if ([self.shapeLayer superlayer]) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    
    self.shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    self.shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.frame = frame;
    self.shapeLayer.masksToBounds = NO;
    [self.shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.strokeColor = [borderColor CGColor];
    self.shapeLayer.lineWidth = borderWidth;
    self.shapeLayer.lineDashPattern =  nil;
    self.shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:self.shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}

-(void)drawDash:(CGFloat)dashPattern
   spacePattern:(CGFloat)spacePattern
   cornerRadius:(CGFloat)cornerRadius
    borderWidth:(CGFloat)borderWidth
    borderColor:(UIColor*)borderColor{
    CGRect frame = self.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [borderColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern], [NSNumber numberWithInt:spacePattern], nil] ;
    _shapeLayer.lineCap = kCALineCapRound;    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:_shapeLayer];
    self.layer.cornerRadius = cornerRadius;
    
}


@end
