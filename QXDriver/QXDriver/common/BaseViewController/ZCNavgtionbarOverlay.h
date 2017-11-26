//
//  ZCNavgtionbarOverlay.h
//  Maroc
//
//  Created by zhangchun on 2016/11/30.
//  Copyright © 2016年 zhangchun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIColor*(^bottomLineColor)(UIColor *color);


@interface ZCNavgtionbarOverlay : UIView

@property(nonatomic,copy)bottomLineColor bottomLineColorBlock;

-(instancetype)initWithFrame:(CGRect)frame
             bottomLineColor:(UIColor*(^)(UIColor *color))bottomLineColor;

@end
