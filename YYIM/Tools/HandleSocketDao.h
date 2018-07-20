//
//  HandleSocketDao.h
//  YYIM
//
//  Created by Jobs on 2018/7/19.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleSocketDao : NSObject
#pragma mark -- 根据  MsgInfoClass  发送通知
+(void)solveWith:(NSDictionary *)receiveDic;








#pragma mark -- 压缩 解压

/**
 把字典转化为 json 并压缩

 @param dictionary 字典
 @return 结果
 */
+(NSData *)getGzipWithDictionary:(NSDictionary *)dictionary;
/**
 把被压缩后的data 转化为 字典
 
 @param GzipData 被压缩后的data
 @return 结果
 */
+(NSDictionary *)getDictionaryWithGzip:(NSData *)GzipData;


/**
 把字典转化为 json 并压缩 并转为base64

 @param dictionary 字典
 @return 结果
 */
+(NSString *)getBase64WithDictionary:(NSDictionary *)dictionary;
/**
 base64 转化为 字典
 
 @param base64 被压缩后 并 base64 后的字符串
 @return 结果
 */
+(NSDictionary *)getDictionaryWithBase64:(NSString*)base64;
@end
