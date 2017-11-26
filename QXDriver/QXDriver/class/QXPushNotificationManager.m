//
//  QXPushNotificationManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/2.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXPushNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
@implementation QXPushNotificationModel@end

@implementation QXContent@end

@implementation QXData@end

@interface QXPushNotificationManager()<UIApplicationDelegate,UNUserNotificationCenterDelegate>
{
    UIBackgroundTaskIdentifier _bgTask;
}
@property(nonatomic,strong)NSMutableDictionary *notifs;
@property(nonatomic,strong)NSMutableDictionary *queues;
@property(nonatomic,strong)NSLock *notificationLock;
@end

@implementation QXPushNotificationManager

static QXPushNotificationManager *__manager = nil;
+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}


-(instancetype)init{
    if (self = [super init]) {
        self.notifs = [[NSMutableDictionary alloc] init];
        self.queues = [[NSMutableDictionary alloc] init];
        self.notificationLock = [[NSLock alloc] init];

    }
    return self;
}

-(void)registerNofitication{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }
    
    // 判读系统版本是否是“iOS 8.0”以上
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
             [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
}

-(void)removeNotificationWithNotificationId:(NSString*)notificationId{
    if (notificationId && notificationId.length) {
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[notificationId]];
    }
}

/**
 **根据实际需求建立本地通知
 **
 **
 **/
-(void)createNotificationWithPushNotificationModel:(QXContent *)model{
    NSString *contentText;
    NSString *requestId = model.data.orderUuid;
    [self removeNotificationWithNotificationId:requestId];
    NSString *queueName = [NSString stringWithFormat:@"notification queue - %@", requestId];
    dispatch_queue_t notificationQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);

    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [self lock];
            [self.notifs setObject:model forKey:requestId];
            [self.queues setObject:notificationQueue forKey:queueName];
        [self unlock];
        if(model.opCode == ORDERMESSAGETYPE_DELIVERY_ORDER){
            contentText = [NSString stringWithFormat:@"%@,%@,%@",@"系统派单",model.data.report,@"请马上联系乘客"];
        }
        else if (model.opCode == SYSTEM_MESSAGETYPE_COMMON){
            NSInteger type = model.data.msgSendType;
            if (type == 2) {
                contentText = model.data.title;
            }
            else{
                contentText = [NSString stringWithFormat:@"%@,%@",model.data.title,model.data.content];
            }
        }
        else{
            contentText = model.data.report;
        }
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = contentText;
        content.badge = 0;
        content.sound = [UNNotificationSound defaultSound];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestId content:content trigger:nil];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
    }
    
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        dispatch_async(notificationQueue, ^{
            
            
            
            [self.notifs removeObjectForKey:requestId];
            [self.queues removeObjectForKey:requestId];
        });

    }
}



#pragma mark ---ios 10 UNUserNotificationCenterDelegate
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //
       
        
    }
    else {
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    completionHandler(UNNotificationPresentationOptionAlert);
}

//点击推送消息后回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSString *requestId = response.notification.request.identifier;
    [self removeNotificationWithNotificationId:requestId];
    [self lock];
        QXContent *model = self.notifs[requestId];
        dispatch_queue_t queue_t = self.queues[requestId];
    [self unlock];
    dispatch_async(queue_t, ^{
        if (completionHandler) {
            completionHandler();
        }
        
        [self.notifs removeObjectForKey:requestId];
        [self.queues removeObjectForKey:requestId];
    });
    
}




-(void)lock{
    [self.notificationLock lock];
}

-(void)unlock{
    [self.notificationLock unlock];
}

@end
