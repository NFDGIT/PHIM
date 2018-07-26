//
//  UserInfoModel.m
//  YYIM
//
//  Created by Jobs on 2018/7/20.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"UserId"] ||[key isEqualToString:@"UserID"] || [key isEqualToString:@"ID"]) {
        [super setValue:value forKey:@"userID"];
        return;
    }

    if ([key isEqualToString:@"UserName"]) {
        [super setValue:value forKey:@"userName"];
        return;
    }
    
    if ([key isEqualToString:@"FriendDicationary"]) {
        return;
    }
    if ([key isEqualToString:@"Groups"]) {
        return;
    }
    [super setValue:value forKey:key];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"UserId"] ||[key isEqualToString:@"UserID"] || [key isEqualToString:@"ID"]) {
        [super setValue:value forKey:@"userID"];
        return;
    }
    
    if ([key isEqualToString:@"UserName"]) {
        [super setValue:value forKey:@"userName"];
        return;
    }
}
-(id)valueForKey:(NSString *)key{
    if ([key isEqualToString:@"FriendDicationary"] || [key isEqualToString:@"Groups"]) {
//        return [super valueForKey:key];
    }
    return [NSString stringWithFormat:@"%@",[super valueForKey:key]];
}
@end
