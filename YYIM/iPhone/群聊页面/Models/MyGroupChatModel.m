//
//  MyGroupChatModel.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyGroupChatModel.h"

@implementation MyGroupChatModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
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
