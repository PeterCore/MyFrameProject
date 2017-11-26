//
//  AppDelegate.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/11.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "AppDelegate.h"
#import "QXDLoginViewController.h"
#import "QXHomeViewController.h"
#import "QXCLLocationManager.h"
#import "QXTrackCorrectManager.h"
#import "NSObject+LKDBHelper.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


-(void)setup{
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    if (QXUserDefaults.token) {
        QXHomeViewController *homeVc = [[QXHomeViewController alloc]init];
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVc];
        [homeNav setNavigationBarHidden:YES];
        self.window.rootViewController = homeNav;
    }
    else{
        QXDLoginViewController *loginVc = [[QXDLoginViewController alloc]init];
        UINavigationController *loginAndRegisterNav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [loginAndRegisterNav setNavigationBarHidden:YES];
        self.window.rootViewController = loginAndRegisterNav;
    }
    
    [self.window makeKeyAndVisible];
    self.window.frame = [[UIScreen mainScreen] bounds];
    //NSLog(@"frame is %f",self.window.frame.size.height);

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[[QXTrackCorrectManager shareManager] removeALLTraceLocations];
    LKDBHelper* globalHelper = [QXTraceLocation getUsingLKDBHelper];

    [[QXCLLocationManager shareManager] startLocationUpdating:^(QXLocationInfo * _Nonnull locationInfo) {
        
    } failuerBlock:^(NSString * _Nonnull errorMessage) {
        
    }];
    [[ZCNetWorkConfiguer shareNetWorkConfiguer] configuerPrefix:@{APIBASEURL:[QXConfiguration shareManager].httpPrefixUrl}];
    [[QXCLLocationManager shareManager] registerCLLocationApiWithKey:[QXConfiguration shareManager].appGDMapKey];
    [self setup];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
