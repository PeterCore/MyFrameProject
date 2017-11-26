//
//  QXPushNotificationManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/2.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QXContent,QXData;
@interface QXPushNotificationModel : NSObject
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *clientUuid;
@property(nonatomic,strong)QXContent *content;
@end

@interface QXContent : NSObject
@property(nonatomic,copy)NSString *pushUuid;
@property(nonatomic,copy)NSString *to;
@property(nonatomic,copy)NSString *appId;
@property(nonatomic,assign)NSInteger opCode;
@property(nonatomic,assign)BOOL needJPush;
@property(nonatomic,strong)QXData *data;
@end

@interface QXData : NSObject
@property(nonatomic,copy)NSString *orderUuid;
@property(nonatomic,assign)NSInteger orderType;
@property(nonatomic,copy)NSString *report;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *deparTime;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)double createTime;
@property(nonatomic,assign)NSInteger retry;
@property(nonatomic,assign)NSInteger msgSendType;

@end


@interface QXPushNotificationManager : NSObject
+(id)shareManager;
-(void)createNotificationWithPushNotificationModel:(QXContent*)model;
-(void)registerNofitication;
@end
