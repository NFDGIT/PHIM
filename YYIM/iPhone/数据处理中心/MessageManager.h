//
//  MessageManager.h
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgModel.h"
#import "ConversationModel.h"



@interface MessageManager : NSObject


+(instancetype)share;

#pragma mark -- 会话
/**
 获取所有的会话
 
 @param success 获取成功
 */
-(void)getConversations:(void (^)(NSArray *))success;

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
 获取某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)getConversationWithId:(NSString *)conversationId response:(void (^)(ConversationModel *model))response;
/**
 为会话设置 新消息个数
 
 @param newCount 新消息个数
 @param conversationId 会话ID
 @param response 结果
 */
-(void)setNewCount:(NSUInteger)newCount withId:(NSString *)conversationId response:(void(^)(BOOL success))response;
/**
 更新会话 不改变顺序
 
 @param conversationModel 新消息个数
 @param response 结果
 */
-(void)updateConversationWith:(ConversationModel *)conversationModel response:(void(^)(BOOL success))response;

/**
 获取新消息总个数
 
 @param response 结果
 */
-(void)getTotalNewCountResponse:(void(^)(NSUInteger totalCount))response;
#pragma mark -- 消息
-(NSArray *)getMessagesWithTargetId:(NSString *)targetId success:(void (^)(NSArray *))success;

-(void)addMsg:(MsgModel *)msg toTarget:(ConversationModel *)target;

/**
 获取最新的消息

 @param targetId 会话ID
 @param response 回调
 */
-(MsgModel *)getLastMessageWithTargetId:(NSString *)targetId response:(void (^)(MsgModel *))response;
/**
 删除 某个会话的聊天记录
 
 @param conversationId 会话ID
 @param response response description
 */
-(void)deleteMessagesWithConversationId:(NSString *)conversationId response:(void(^)(BOOL success))response;
#pragma mark -- 处理 socket 收到的数据
-(void)handleMewMsg;
@end
