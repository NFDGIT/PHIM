//
//  NSString+Helper.m
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)
-(BOOL)isEmptyString{
    return !self || [self isKindOfClass:[NSNull class]]|| [self isEqualToString:@"<null>"] || [self isEqualToString:@"(null)"] || [self isEqualToString:@"null"];
    
}
@end
