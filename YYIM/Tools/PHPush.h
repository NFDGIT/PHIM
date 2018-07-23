//
//  PHPush.h
//  YYIM
//
//  Created by Jobs on 2018/7/23.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHPush : NSObject
//创建本地通知
+ (void)registLocalPush;
+ (void)push:(NSString *)message;
@end
