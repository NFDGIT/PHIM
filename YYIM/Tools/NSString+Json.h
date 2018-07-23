//
//  NSString+Json.h
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)
// 字典转json字符串方法

+(NSString *)convertToJsonData:(NSDictionary *)dict;
// json字符串转字典方法
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// oc 对象 转json字符串方法
+(NSString *)getJsonStringWithObjc:(id )objc;
// json字符串转oc 对象方法
+ (id )getObjcWithJsonString:(NSString *)jsonString;
@end
