//
//  PHAlert.h
//  YYIM
//
//  Created by Jobs on 2018/7/20.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHAlert : NSObject
+(void)showWithTitle:(NSString *)title message:(NSString *)message block:(void(^)(void))block;
+(void)showConfirmWithTitle:(NSString *)title message:(NSString *)message block:(void(^)(BOOL sure))block;
@end
