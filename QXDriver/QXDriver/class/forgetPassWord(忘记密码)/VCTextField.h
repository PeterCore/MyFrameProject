//
//  QXTextField.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCTextField;
@protocol VCTextFieldDelegate <NSObject>

-(void)deleteBackWard:(VCTextField*)textField;

@end

@interface VCTextField : UITextField
@property(nonatomic,weak)id<VCTextFieldDelegate>backDelegate;

@end
