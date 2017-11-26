//
//  NSMutableAttributedString+ZCHelper.h
//  FamilyEdu
//
//  Created by zhangchun on 2017/6/28.
//  Copyright © 2017年 ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (ZCHelper)
-(NSInteger)layoutlineWithAttributedString: (CGSize) size;
-(NSMutableAttributedString*)layoutFontWithAttributedString: (CGSize) size
                                                moreContent: (NSString*)content
                                                  limitLine: (NSInteger)limitLine;
@end
