//
//  BaseDB.h
//  user
//
//  Created by warren on 15/10/22.
//  Copyright © 2015年 zhangchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface BaseDB : NSObject

@end


//这个NSOBJECT的扩展类 可以查看详细的建表sql语句
@interface NSObject(PrintSQL)
+(NSString*)getCreateTableSQL;
@end