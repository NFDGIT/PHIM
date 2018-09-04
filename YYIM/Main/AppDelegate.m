//
//  AppDelegate.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "LoginViewController.h"
#import "NetTool.h"
#import "PHPush.h"
#import "DBTool.h"
#import "SocketRequest.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [NetTool detectionNet];
    [PHPush registLocalPush];
    [self switchRootVC];
 
    
    return YES;
}
-(void)switchRootVC{
    TabBarController * tabbar = [TabBarController share];
    
    LoginViewController * loginVC = [LoginViewController new];
    
    if ([CurrentUserId isEmptyString]) {
        self.window.rootViewController = loginVC;
        [[SocketTool share] stopHeartBeat]; // 停止心跳爆
        [[NetTool share] startDetection];   // 停止检测服务器

        
    }else
    {
        self.window.rootViewController = tabbar;
        [[SocketTool share] startHeartBeat]; // 开始心跳爆
        [[NetTool share] startDetection];    // 开始检测服务器
        [[DBTool share]createAccountDb];     // 初始化数据库
        [SocketRequest login];               // socket 发送上线通知
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [SocketRequest getOffLineMessage];   // 请求离线消息
        });

        
        
    };
}
-(void)logout{
    [SocketRequest logout];
    
    setCurrentUserId(@"");
    setCurrentUserIcon(@"");
    setCurrentUserName(@"");
    setCurrentUserStatus(0);
    setCurrentUserUnderWrite(@"");

 
    
    [self switchRootVC];
}

- (void)beginBgTask{
    [PHPush registLocalPush];
    //    //开启后台处理多媒体事件
    //  [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    //    AVAudioSession*session=[AVAudioSession sharedInstance];
    //  [session setActive:YES error:nil];
    //    //后台播放
    //  [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    UIApplication * app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    
    //  开启后台时间 并返回一个任务 标识
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (bgTask != UIBackgroundTaskInvalid) {
            bgTask = UIBackgroundTaskInvalid;
        }
    });
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self beginBgTask];

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
