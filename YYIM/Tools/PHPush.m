//
//  PHPush.m
//  YYIM
//
//  Created by Jobs on 2018/7/23.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PHPush.h"

@implementation PHPush
//创建本地通知
+ (void)registLocalPush
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}
+ (void)push:(NSString *)message{
    // 1.创建通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 2.设置通知的必选参数
    // 设置通知显示的内容
    localNotification.alertBody = message;
    // 设置通知的发送时间,单位秒
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    //解锁滑动时的事件
    localNotification.alertAction = @"查看";
    //收到通知时App icon的角标
    localNotification.applicationIconBadgeNumber = 1;
    //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 3.发送通知(🐽 : 根据项目需要使用)
    // 方式一: 根据通知的发送时间(fireDate)发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // 方式二: 立即发送通知
    // [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    

    
}
@end
