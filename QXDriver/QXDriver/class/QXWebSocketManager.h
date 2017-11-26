//
//  QXWebSocketManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/9/23.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QXWebSocketManager : NSObject

+(instancetype)shareManager;

-(void)sendMessage:(NSDictionary*)messageDictionary successBlock:(void(^)(NSDictionary *messageDictionary))successBlock
      failuerBlock:(void(^)(NSError *error))failuerBlock;


@end
