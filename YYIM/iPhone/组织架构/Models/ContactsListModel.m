//
//  ContactsListModel.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ContactsListModel.h"

@implementation ContactsListModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"Nodes"]) {
        NSMutableArray * models = [NSMutableArray array];
        for (NSDictionary * dic  in value) {
            ContactsListModel * model = [ContactsListModel new];
            [model setValuesForKeysWithDictionary:dic];
            [models addObject:model];
        }
        [super setValue:models forKey:key];
        return;
    }
    [super setValue:value forKey:key];
}
//-(NSMutableArray *)getModelsWithDatas:(NSArray *)datas{
//    
//    NSMutableArray * models = [NSMutableArray array];
//    if (datas && [datas isKindOfClass:[NSArray class]]) {
//   
//        for (NSDictionary * dic  in datas) {
//            ContactsListModel * model = [ContactsListModel new];
//            [model setValuesForKeysWithDictionary:dic];
//            [models addObject:model];
//        }
//    }
//    return models;
//}
@end
