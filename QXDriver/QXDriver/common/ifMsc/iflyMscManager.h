//
//  iflyMscManager.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/3.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/IFlyMSC.h>
#import <AVFoundation/AVFoundation.h>
@interface iflyMscManager : NSObject<IFlySpeechSynthesizerDelegate>

+(instancetype)shareManager;
-(void)registerIflyMsc;
-(void)startSyntheticSpeechWithText:(NSString *)text;
-(void)stopAudio;
@end
