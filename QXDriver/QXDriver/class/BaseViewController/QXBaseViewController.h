//
//  QXBaseViewController.h
//  QXDriver
//
//  Created by zhangchun on 2017/11/30.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "ZCBaseViewController.h"
#import "QXCLLocationManager.h"
@interface QXBaseViewController : ZCBaseViewController

-(void)fetchCurrentLocation:(QXLocationInfo*)locationInfo failuerError:(NSString*)failuerError;

@end
