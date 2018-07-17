//
//  NSDictionary+Helper.m
//  YYIM
//
//  Created by Jobs on 2018/7/17.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)
+(NSDictionary *)getParamDicWithUrl:(NSString *)url{
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    
    if ([url containsString:@"?"]) {
        NSRange range = [url rangeOfString:@"?"];
        NSString * urlParam = [url substringFromIndex:range.location + range.length];
        
        NSArray * paramStrings = [urlParam componentsSeparatedByString:@"&"];
        for (NSString * paramString in paramStrings) {
            
            NSArray * keyvalues = [paramString componentsSeparatedByString:@"="];
            [paramDic setValue:keyvalues.lastObject forKey:keyvalues.firstObject];
        }
    }
    return paramDic;
}
@end
