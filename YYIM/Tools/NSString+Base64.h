//
//  NSString+Base64.h
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
+ (NSString *)encode:(NSString *)string;
+ (NSString *)dencode:(NSString *)base64String;
@end
