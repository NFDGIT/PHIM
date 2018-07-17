//
//  RishTextAdapter.m
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "RishTextAdapter.h"
@interface RishTextAdapter()
@property (nonatomic,strong)NSMutableArray * replaceArr;
@end
@implementation RishTextAdapter
+(NSAttributedString *)getAttributedStringWithString:(NSString *)string{
    string = @"fdsafdsa[:f13]dsaf[:f4]";
//  NSMutableString * mstring
    
    
    NSMutableAttributedString * mastring = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableString * mstring = [[NSMutableString alloc]initWithString:string];
    
    NSTextCheckingResult * match;
    while ((match = [RishTextAdapter getMatchString:mstring])) {
        NSRange range = match.range;
        
        NSString * rangeString = [string substringWithRange:range];
        [mstring replaceCharactersInRange:range withString:@""];
        
        
        NSTextAttachment * attachment = [NSTextAttachment new];
        attachment.image = [RishTextAdapter getImageWithString:rangeString];
        NSAttributedString * replaceAtt = [NSAttributedString attributedStringWithAttachment:attachment];
        [mastring replaceCharactersInRange:range withAttributedString:replaceAtt];
    
    }
    
    return mastring;
    
}
+(NSTextCheckingResult * )getMatchString:(NSString *)string{
    NSString *url = string;
    NSError *error;
    // 创建NSRegularExpression对象并指定正则表达式
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[[^\\]]+\\]"
                                  options:0
                                  error:&error];
    if (!error) { // 如果没有错误
        // 获取特特定字符串的范围
        NSTextCheckingResult *match = [regex firstMatchInString:url
                                                        options:0
                                                          range:NSMakeRange(0, [url length])];
        if (match) {
            // 截获特定的字符串
            NSString *result = [url substringWithRange:match.range];
            return  match;
        }
        return nil;
    } else { // 如果有错误，则把错误打印出来
        return nil;
    }
}
+(UIImage *)getImageWithString:(NSString *)string{
    NSString * mstring = [NSMutableString stringWithString:string];

    
    if ([mstring hasPrefix:@"[:f"] && [mstring hasSuffix:@"]"]) {
        mstring = [mstring stringByReplacingOccurrencesOfString:@"[:f" withString:@""];
        mstring = [mstring stringByReplacingOccurrencesOfString:@"]" withString:@""];
    }
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"Emotion.bundle/%@.gif",mstring]];
    
    return image;
}

@end
