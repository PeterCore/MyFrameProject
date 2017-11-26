//
//  iflyMscManager.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/3.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "iflyMscManager.h"
#import "PcmPlayer.h"

@interface iflyMscManager(){
    
    NSString *_uriPath;
    UIBackgroundTaskIdentifier _bgTask;
    
}
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer; // 语音合成管理类
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@end

@implementation iflyMscManager


static iflyMscManager *__manager = nil;

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        self.iFlySpeechSynthesizer.delegate = self;
        self.audioPlayer = [[PcmPlayer alloc] init];
        NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
        [self.iFlySpeechSynthesizer setParameter:@"80" forKey:[IFlySpeechConstant SPEED]];
        [self.iFlySpeechSynthesizer setParameter:@"3" forKey:[IFlySpeechConstant VOLUME]];
        [self.iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        [self.iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    }
    return self;
}

-(void)registerIflyMsc{
    [IFlySetting setLogFile:LVL_ALL];
    [IFlySetting showLogcat:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",[QXConfiguration shareManager].ifMSCKey];
    [IFlySpeechUtility createUtility:initString];
}


-(void)startSyntheticSpeechWithText:(NSString *)text{
    
    if ([text isEqualToString:@""]) {
        return;
    }
    if (self.audioPlayer != nil && self.audioPlayer.isPlaying == YES) {
        [self stopAudio];
    }
    
    [NSThread sleepForTimeInterval:0.05];
    
    [self.iFlySpeechSynthesizer synthesize:text toUri:_uriPath];
    if (self.iFlySpeechSynthesizer.isSpeaking) {
        
    }

}

-(void)stopAudio{
    [self.audioPlayer stop];
    [self.iFlySpeechSynthesizer stopSpeaking];
    
}

-(void)playAudio{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [session setActive:YES error:nil];
    if (_bgTask && _bgTask == UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
    }
    NSData *audioData = [NSData dataWithContentsOfFile:_uriPath];
    [self.audioPlayer writeWaveHead:audioData sampleRate:16000];
    [self.audioPlayer play];
    
    _bgTask = UIBackgroundTaskInvalid;
    UIApplication* app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if(_bgTask != UIBackgroundTaskInvalid){
                _bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_bgTask != UIBackgroundTaskInvalid){
                _bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

}

#pragma mark --- IFlySpeechSynthesizerDelegate

- (void)onBufferProgress:(int)progress message:(NSString *)msg
{
    
    
}



- (void) onSpeakProgress:(int)progress beginPos:(int)beginPos endPos:(int)endPos
{
    
   
}

- (void)onSpeakPaused
{
    
    
}

- (void)onCompleted:(IFlySpeechError *) error
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_uriPath]) {
        [self playAudio];
    }
    
}

@end
