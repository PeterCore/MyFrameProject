//
//  QXTextField.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "VCTextField.h"

@implementation VCTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)deleteBackward{
    [super deleteBackward];
    if ([self.backDelegate respondsToSelector:@selector(deleteBackWard:)]) {
        [self.backDelegate  deleteBackWard:self];
    }
}

@end
