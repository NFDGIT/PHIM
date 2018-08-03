//
//  GroupChatModel.m
//  YYIM
//
//  Created by Jobs on 2018/8/3.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "GroupChatModel.h"

@implementation GroupChatModel
-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"memberList"]) {
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dic in value) {
            MyFriendsModel * model = [MyFriendsModel new];
            [model setValuesForKeysWithDictionary:dic];
            [arr addObject:model];
        }
        [super setValue:arr forKey:key];
        return;
    }
    [super setValue:value forKey:key];
    
}

@end
