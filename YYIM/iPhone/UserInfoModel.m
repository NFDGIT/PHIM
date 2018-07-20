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
    if ([key isEqualToString:@"FriendDicationary"]) {
        return;
    }
    if ([key isEqualToString:@"Groups"]) {
        return;
    }
    [super setValue:value forKey:key];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"UserId"]) {
        [super setValue:value forKey:@"userID"];
    }
    if ([key isEqualToString:@"UserID"]) {
        [super setValue:value forKey:@"userID"];
    }
    if ([key isEqualToString:@"UserName"]) {
        [super setValue:value forKey:@"userName"];
    }
}
@end
