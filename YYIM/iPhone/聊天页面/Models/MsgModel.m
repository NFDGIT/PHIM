//
//  MsgModel.m
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MsgModel.h"
#import "NSString+Json.h"

@implementation MsgModel
+(NSDictionary *)getFileDicWithFileJson:(NSString *)fileJson{
    NSDictionary * dic = [NSString dictionaryWithJsonString:fileJson];
    return dic;
}

@end
