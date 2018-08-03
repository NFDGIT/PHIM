//
//  PHPush.h
//  YYIM
//
//  Created by Jobs on 2018/7/23.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IOS11_LATER   ([[UIDevice currentDevice] systemVersion] >= 11)
@interface PHPush : NSObject
//创建本地通知
+ (void)registLocalPush;
+ (void)pushWithTitle:(NSString *)title message:(NSString *)message;
+(void)setBageNumber:(NSInteger)count;
+(void)refreshBage;
@end
