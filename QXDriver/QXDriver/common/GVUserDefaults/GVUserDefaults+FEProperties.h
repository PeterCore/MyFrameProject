//
//  GVUserDefaults+FEProperties.h
//  FamilyEdu
//
//  Created by zhangchun on 2017/6/2.
//  Copyright © 2017年 ye. All rights reserved.
//

#import "GVUserDefaults.h"

#define QXUserDefaults [GVUserDefaults standardUserDefaults]


@interface GVUserDefaults (FEProperties)
@property(nonatomic, copy)NSString *uid;
@property(nonatomic, copy)NSString *avatarUrl;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *cid;
@property(nonatomic, copy)NSString *mid;
@property(nonatomic, assign)BOOL used;
@property(nonatomic, assign)NSInteger identity;
@property(nonatomic, strong)NSData *avatarImageData;
@property(nonatomic, assign)CGFloat latitude;
@property(nonatomic, assign)CGFloat longitude;
@property(nonatomic, copy)NSString *token;

@end
