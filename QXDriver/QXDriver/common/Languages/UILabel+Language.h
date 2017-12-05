//
//  UILabel+Language.h
//  QXDriver
//
//  Created by zhangchun on 2017/12/1.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCLanguageConfigueration.h"

@interface UILabel (Language)
-(ZCConfiguerationLanguageBlock)makeLanguage;
-(ZCConfiguerationMutableAttributeLanguageBlock)makeAttributeLanguage;
-(void)switchLanguage;
@end
