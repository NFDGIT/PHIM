//
//  DBTool.h
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgModel.h"
#import "ConversationModel.h"
#import "UserInfoModel.h"
//#import "PersonStatusModel.h"

@interface DBTool : NSObject
+(instancetype)share;
#pragma mark -- 私人数据库
-(void)createAccountDb;

#pragma mark -- 消息
/**
 向 数据库中插入数据
 
 @param model 插入的数据
 @param target target description
 @param response response description
 */
-(void)addModel:(MsgModel *)model withTarget:(NSString *)target response:(void(^)(BOOL success))response;
/**
 删除 某个会话的聊天记录
 
 @param conversationId 会话ID
 @param response response description
 */
-(void)deleteMessagesWithConversationId:(NSString *)conversationId response:(void(^)(BOOL success))response;

/**
 根据 target 获取 数据库中的 所有聊天数据

 @param target 用来标记这是哪个账号的聊天记录
 @param success 查询成功的回调
 */
-(NSArray *)getMessagesWithTarget:(NSString *)target success:(void(^)(NSArray*result))success;





#pragma mark -- 会话


/**
 添加会画

 @param model 会话的模型
 @param response 添加会话的结果
 */
-(void)addConversationModel:(ConversationModel *)model response:(void (^)(BOOL))response;
/**
 删除某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)deleteConversationId:(NSString *)conversationId response:(void (^)(BOOL))response;


/**
 更新会话 不改变顺序
 
 @param conversationModel 新消息个数
 @param response 结果
 */
-(void)updateConversationWith:(ConversationModel *)conversationModel response:(void(^)(BOOL success))response;

/**
 获取某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)getConversationWithId:(NSString *)conversationId response:(void (^)(ConversationModel * model))response;
/**
 获取所有的会话
 
 @param success 获取成功
 */
-(void)getConversations:(void (^)(NSArray *))success;

#pragma mark -- 用户信息

/**
 添加用户信息
 
 @param model 用户信息model
 @param response 添加用户信息的结果
 */
-(void)addUserModel:(UserInfoModel *)model response:(void (^)(BOOL))response;
/**
 更新用户信息
 
 @param model 用户信息model
 @param response 添加用户信息的结果
 */
-(void)updateUserModel:(UserInfoModel *)model response:(void (^)(BOOL))response;
/**
 获取所有的用户信息
 
 @param success 获取成功
 */
-(void)getUserModels:(void (^)(NSDictionary *))success;

/**
 根据 userid 获取 model

 @param userId 用户id
 @param model 用户的model
 */
-(void)getUserModelWithUserId:(NSString *)userId response:(UserInfoModel *)model;
@end
