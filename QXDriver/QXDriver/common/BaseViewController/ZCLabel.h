//
//  ZCLabel.h
//  Maroc
//
//  Created by zhangchun on 2016/11/30.
//  Copyright © 2016年 zhangchun. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , ZCFlashCtntSpeed){
    ZCFlashCtntSpeedSlow = -1,
    ZCFlashCtntSpeedMild,
    ZCFlashCtntSpeedFast
};


@interface ZCLabel : UIView


@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;         // 默认:system(15)
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSAttributedString *attributedText;
@property (nonatomic, assign) ZCFlashCtntSpeed speed;
// 循环滚动次数(为0时无限滚动)
@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, assign) CGFloat leastInnerGap;
- (void)reloadView;

@end
