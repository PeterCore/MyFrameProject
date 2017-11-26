//
//  ZCMatrix.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/23.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCMatrix.h"
#import <Accelerate/Accelerate.h>

@interface ZCMatrix()

@end

@implementation ZCMatrix


+(ZCMatrix*)initWithDimensions:(NSUInteger)rows colunms:(NSUInteger)columns{
    NSAssert(columns > 0 && rows >0, @"columns and rows must to be > 0");
    ZCMatrix *matrix = [ZCMatrix new];
    matrix.rows      =  rows;
    matrix.columns   = columns;
    matrix.data      = (double*)malloc(sizeof(double)* rows*columns);
    memset((void*)matrix.data, 0, sizeof(double)* rows*columns);
    return matrix;
}

+(ZCMatrix*)rows:(NSUInteger)rows columns:(NSUInteger)columns values:(double)m, ...{
    ZCMatrix* matrix = [ZCMatrix initWithDimensions:rows colunms:columns];
    va_list list;
    va_start(list,m);
    matrix.data[0]=m;
    for(int i=1; i<rows*columns; i++) matrix.data[i] = va_arg(list,double);
    va_end(list);
    return matrix;
}


-(ZCMatrix*) transpose
{
    ZCMatrix* output = [ZCMatrix initWithDimensions:_columns colunms:_rows];
    vDSP_mtransD(_data, 1, output.data, 1, _columns, _rows);
    return output;
}

-(ZCMatrix*) invertmatrix
{
    ZCMatrix* output = [self copy];
    
    int error=0;
    int* pivot        = (int*) malloc(MIN(_rows, _columns)*sizeof(int));
    double* workspace = (double*) malloc(MAX(_rows, _columns)*sizeof(double));
    
    //  LU factorisation
    __CLPK_integer M = (__CLPK_integer)_rows;
    __CLPK_integer N = (__CLPK_integer)_columns;
    __CLPK_integer LDA = MAX(M,N);
    dgetrf_(&M, &N, output.data, &LDA, pivot, &error);
    
    if (error)
        {
        NSLog(@"LU factorisation failed");
        free(pivot);
        free(workspace);
        return nil;
        }
    
    //  matrix inversion
    dgetri_(&N, output.data, &N, pivot, workspace, &N, &error);
    if (error)
        {
        NSLog(@"Invesrion Failed");
        free(pivot);
        free(workspace);
        return nil;
        }
    
    free(pivot);
    free(workspace);
    
    return output;
}


-(ZCMatrix*) add:(ZCMatrix*)B
{
    NSAssert(_rows==B.rows, @"Method Add: Matrixes haven't same number of rows: %lu ≠ %lu", (unsigned long)_rows, (unsigned long)B.rows);
    NSAssert(_columns==B.columns, @"Method Add: Matrixes haven't same number of columns : %lu ≠ %lu", (unsigned long)_columns, (unsigned long)B.columns);
    
    ZCMatrix* output = [ZCMatrix initWithDimensions:_rows colunms:_columns];
    vDSP_vaddD(self.data, 1, B.data, 1, output.data, 1, _rows*_columns);
    
    return output;
    
}
-(ZCMatrix*) sub:(ZCMatrix*)B
{
    NSAssert(_rows==B.rows, @"Method Substract: Matrixes haven't same number of rows: %lu ≠ %lu", (unsigned long)_rows, (unsigned long)B.rows);
    NSAssert(_columns==B.columns, @"Method Substract: Matrixes haven't same number of columns : %lu ≠ %lu", (unsigned long)_columns, (unsigned long)B.columns);
    double neg = -1.0;
    
    ZCMatrix* output = [ZCMatrix initWithDimensions:_rows colunms:_columns];
    vDSP_vsmaD(B.data, 1, &neg, self.data, 1, output.data, 1, _rows*_columns);
    
    return output;
}

-(ZCMatrix*) multiplyByTransposeOf:(ZCMatrix*)B
{
    NSAssert(_columns==B.columns, @"Method multiplyByTransposeOf: Left Matrix number of columns ≠ Right Matrix number of columns: %lu ≠ %lu", (unsigned long)_columns, (unsigned long)B.columns);
    return [self multiplyBy:[B transpose]];
}

-(ZCMatrix*) multiplyBy:(ZCMatrix*)B
{
    NSAssert(_columns==B.rows, @"Method Multiply: Left Matrix number of columns ≠ Right Matrix number of Rows: %lu ≠ %lu", (unsigned long)_columns, (unsigned long)B.rows);
    ZCMatrix* output = [ZCMatrix initWithDimensions:_rows colunms:B.columns];
    vDSP_mmulD(self.data, 1, B.data, 1, output.data, 1, _rows, B.columns, _columns);
    return output;
}

-(ZCMatrix*) copy
{
    ZCMatrix* output = [ZCMatrix initWithDimensions:_rows colunms:_columns];
    memcpy(output.data, _data, _rows*_columns*sizeof(double));
    return output;
}

-(void) setIdentity
{
    for(int r=0; r<_rows; r++)
    {
        for(int c=0; c<_columns; c++)
        {
            _data[c + r*_columns] = r==c ? 1.0 : 0.0;
        }
    }
}

+(ZCMatrix*) getIdentity:(NSUInteger)dim
{
    ZCMatrix *matrix = [ZCMatrix initWithDimensions:dim colunms:dim];
    for(int r=0; r<dim; r++)
    {
        for(int c=0; c<dim; c++)
        {
             matrix.data[c + r*dim] = r==c ? 1.0 : 0.0;
        }
    }
    return matrix;
}

- (void) dealloc
{
    free(_data);
}
@end
