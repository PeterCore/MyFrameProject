//
//  ZCMatrix.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/23.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCMatrix : NSObject
@property(nonatomic, assign)NSUInteger rows;
@property(nonatomic, assign)NSUInteger columns;
@property(nonatomic, assign)double* data;

+(ZCMatrix*)initWithDimensions:(NSUInteger)rows colunms:(NSUInteger)columns;
+(ZCMatrix*) rows:(NSUInteger)rows columns:(NSUInteger)column values:(double)m,...;
// C = A^T
-(ZCMatrix*) transpose;
-(ZCMatrix*) invertmatrix;

-(ZCMatrix*) add:(ZCMatrix*)B;
-(ZCMatrix*) sub:(ZCMatrix*)B;
-(ZCMatrix*) multiplyBy:(ZCMatrix*)B;
-(ZCMatrix*) multiplyByTransposeOf:(ZCMatrix*)B;
-(void) setIdentity;

+(ZCMatrix*) getIdentity:(NSUInteger)dim;
@end
