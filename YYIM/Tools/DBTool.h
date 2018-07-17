//
//  DBTool.h
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgModel.h"
#import "MessageTargetModel.h"

@interface DBTool : NSObject
+(instancetype)share;
//-(void)createDB;




/**
 根据 target 获取 数据库中的 所有聊天数据

 @param target 用来标记这是哪个账号的聊天记录
 @param success 查询成功的回调
 */
-(void)getMessagesWithTarget:(NSString *)target success:(void(^)(NSArray*result))success;

/**
 向 数据库中插入数据

 @param model 插入的数据
 @param target target description
 @param response response description
 */
-(void)addModel:(MsgModel *)model withTarget:(NSString *)target response:(void(^)(BOOL success))response;


-(void)getChatPersons:(void(^)(NSArray *result))success;
-(void)addTargetModel:(MessageTargetModel *)model response:(void (^)(BOOL))response;

@end
