//
//  QXWebSocketManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/23.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXWebSocketManager.h"
#import <SocketRocket/SocketRocket.h>

static NSInteger pingLoopTime = 15;

@interface QXBlock : NSObject

@end


@implementation QXBlock

@end

@interface QXWebSocketManager()<SRWebSocketDelegate>{
    dispatch_semaphore_t _socketOpenSemaphore;
    SRWebSocket *_webSocket;
    dispatch_queue_t _queue;
    NSMutableDictionary *_queues;
    NSMutableDictionary *_callbacks;
    NSTimer *_timer;
}
@property(nonatomic,copy)void(^successBlock)(NSDictionary *successDictionary);
@property(nonatomic,copy)void(^failuerBlock)(NSError *error);
@property(nonatomic,strong) NSLock *weblock;
@end


@implementation QXWebSocketManager

static QXWebSocketManager *__manager = nil;

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}


-(instancetype)init{
    if (self = [super init]) {
        _queues = [NSMutableDictionary dictionary];
        _callbacks = [NSMutableDictionary dictionary];
        self.weblock = [[NSLock alloc] init];
        if (!_queue) {
            _queue = dispatch_queue_create([@"QXWebSocket.queue.com" UTF8String], DISPATCH_QUEUE_SERIAL);
        }
        if (![self __connect]) {
            [self invalidate];
            NSString *error = [NSString stringWithFormat:@"Connection to %@ timed out,", [QXConfiguration shareManager].wsPrefixUrl];
            NSLog(@"%@",error);
        }
    }
    return self;
}

-(BOOL)__connect{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[QXConfiguration shareManager].wsPrefixUrl]];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    [_webSocket setDelegateDispatchQueue:_queue];
    
    _socketOpenSemaphore = dispatch_semaphore_create(0);
    [_webSocket open];
    long connected = dispatch_semaphore_wait(_socketOpenSemaphore, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5));
    return connected == 0 && _webSocket.readyState == SR_OPEN;
}


-(void)reconnect{
    [self invalidate];
    [self __connect];
}

-(void)invalidate{
    _webSocket.delegate = nil;
    [_webSocket closeWithCode:1000 reason:@"Invalidated"];
    _webSocket = nil;
    [_timer invalidate];
    _timer = nil;
}

-(void)sendMessage:(NSDictionary *)messageDictionary successBlock:(void (^)(NSDictionary *))successBlock failuerBlock:(void (^)(NSError *))failuerBlock{
    
    NSError *error ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    NSString *bodyData =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [_webSocket send:bodyData];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    dispatch_semaphore_signal(_socketOpenSemaphore);
    [self sendQXping];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    dispatch_semaphore_signal(_socketOpenSemaphore);
    [self reconnect];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
}


- (BOOL)isValid
{
    return _webSocket != nil && _webSocket.readyState == SR_OPEN;
}


-(void)lock{
    [self.weblock lock];
}

-(void)unlock{
    [self.weblock unlock];
}

/*
 *
 *
 *
 */
-(void)sendQXping{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:pingLoopTime target:self selector:@selector(sendPingTimer:) userInfo:nil repeats:YES];
    }
    
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if(bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
}

-(void)sendPingTimer:(NSTimer*)timer{
    
}


@end
