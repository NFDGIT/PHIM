//
//  PHAlert.m
//  YYIM
//
//  Created by Jobs on 2018/7/20.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PHAlert.h"



@implementation PHAlert
+(void)showWithTitle:(NSString *)title message:(NSString *)message block:(void (^)(void))block{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    [alert addAction:action];
    [[[[UIApplication sharedApplication] keyWindow]rootViewController]presentViewController:alert animated:YES completion:^{
    }];
}
@end
