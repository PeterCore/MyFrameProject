//
//  QXBaseResponse.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/15.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXBaseResponse : NSObject
@property(nonatomic,assign)NSInteger counts;
@property(nonatomic,assign)NSInteger error;
@property(nonatomic,copy)  NSString *msg;
@property(nonatomic,assign)NSInteger success;
@end
