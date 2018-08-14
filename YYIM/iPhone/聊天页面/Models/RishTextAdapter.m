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
    
    NSMutableAttributedString * mastring = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",string]];
    NSMutableString * mstring = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",string]];
    
    NSArray * results = [RishTextAdapter getResultsWithString:mstring];
    
    for (int i = 0; i < results.count ; i++ ) {
        NSTextCheckingResult * result = results[results.count - i - 1];
        NSRange range = result.range;
        NSString * rangeString = [string substringWithRange:range];
        
        
        NSTextAttachment * attachment = [NSTextAttachment new];
        attachment.image = [RishTextAdapter getImageWithString:rangeString];
        NSAttributedString * replaceAtt = [NSAttributedString attributedStringWithAttachment:attachment];
        [mastring replaceCharactersInRange:range withAttributedString:replaceAtt];

    }
    
    return mastring;
    
}
+(NSArray *)getResultsWithString:(NSString *)string{
    NSString *url = string;
    NSError *error;
    NSArray * results = [NSArray array];
    
    // 创建NSRegularExpression对象并指定正则表达式
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[:f[^\\]]+\\]"
                                  options:0
                                  error:&error];
    if (!error) { // 如果没有错误
        // 获取特特定字符串的范围
       results  = [regex matchesInString:url options:0 range:NSMakeRange(0, [url length])];
        
    } else { // 如果有错误，则把错误打印出来
    }
    return results;
}
+(UIImage *)getImageWithString:(NSString *)string{
    NSString * mstring = [NSMutableString stringWithString:string];

    
    if ([mstring hasPrefix:@"[:f"] && [mstring hasSuffix:@"]"]) {
        mstring = [mstring stringByReplacingOccurrencesOfString:@"[:f" withString:@""];
        mstring = [mstring stringByReplacingOccurrencesOfString:@"]" withString:@""];
        
    
    }
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"Emotion.bundle/%@.gif",mstring]];
    image.text_tag = [NSString stringWithFormat:@"[:f%@]",mstring];
    
    return image;
}

+(NSString *)getStringWithAttributedString:(NSAttributedString *)attributedString{
    __block NSString * result = @"";
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment * attachment = attrs[@"NSAttachment"];
        if ([attachment isKindOfClass:[NSTextAttachment class]]) {
            UIImage * image = attachment.image;
            if ([image.text_tag hasPrefix:@"["] && [image.text_tag hasSuffix:@"]"]) {
                result = [result stringByAppendingString:image.text_tag];
            }

            
            
        }else{
            
            result = [result stringByAppendingString:[[attributedString attributedSubstringFromRange:range] string]];
        }
    }];
    
    return result;
}

@end
