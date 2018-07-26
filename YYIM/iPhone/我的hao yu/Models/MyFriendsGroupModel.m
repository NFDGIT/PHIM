//
//  MyFriendsGroupModel.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyFriendsGroupModel.h"

@implementation MyFriendsGroupModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"Friend"]) {
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * dic in value) {
            MyFriendsModel * model = [MyFriendsModel new];
            [model setValuesForKeysWithDictionary:dic];
            [array addObject:model];
        }
        [super setValue:array forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}
@end
