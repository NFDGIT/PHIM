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
#pragma mark -- 消息


-(void)getMessagesWithTargetId:(NSString *)targetId success:(void (^)(NSArray *))success;
-(void)addMsg:(MsgModel *)msg toTarget:(ConversationModel *)target;

#pragma mark -- 处理 socket 收到的数据
-(void)handleMewMsg;
@end
