//
//  MessageManager.m
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MessageManager.h"
#import "DBTool.h"

static MessageManager *shared = nil;

@interface MessageManager()
@property (nonatomic,strong)NSMutableDictionary * messageDic;

@property (nonatomic,strong)NSMutableArray * messageTargets;
@end
@implementation MessageManager

+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [MessageManager new];
        [shared initData];
        [shared handleMewMsg];
    });
    
    return shared;
}
-(void)initData{
    _messageTargets = [NSMutableArray array];
    _messageDic = [NSMutableDictionary dictionary];
    
    
}


#pragma mark -- 会话
/**
 获取所有的会话
 
 @param success 获取成功
 */
-(void)getConversations:(void (^)(NSArray *))success{
    [[DBTool share]getConversations:^(NSArray *result) {
        if (success){
            success(result);
        }
    }];
}

/**
 添加会画
 
 @param model 会话的模型
 @param response 添加会话的结果
 */
-(void)addConversationModel:(ConversationModel *)model response:(void (^)(BOOL))response{
    [[DBTool share] addConversationModel:model response:^(BOOL success) {
        if (response) {
            response(success);
        }
    }];
    
}

/**
 删除某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)deleteConversationId:(NSString *)conversationId response:(void (^)(BOOL))response{
    [[DBTool share] deleteConversationId:conversationId response:^(BOOL success) {
        if (response) {
            response(success);
        }
    }];
}
/**
 获取某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)getConversationWithId:(NSString *)conversationId response:(void (^)(ConversationModel *model))response{
    [[DBTool share]getConversationWithId:conversationId response:^(ConversationModel *model) {
        if (response) {
            response(model);
        }
    }];
    
}
//-(void)getMsgTargetsSuccess:(void (^)(NSArray *))success{
////    NSArray * msgTargets = [NSArray array];
////    if (_messageTargets) {
////        msgTargets = _messageTargets;
////    }
////    return msgTargets;
//    [[DBTool share] getChatPersons:^(NSArray *result) {
//        if (success){
//            success(result);
//        }
//    }];
//
//}

//-(void)addMsgTarget:(MessageTargetModel *)target{
//    [[DBTool share] addTargetModel:target response:^(BOOL success) {
//
//    }];
//
//}




#pragma mark -- 消息
-(void)getMessagesWithTargetId:(NSString *)targetId success:(void (^)(NSArray *))success{
//    NSArray * messages = [NSArray array];
//
//    if ([_messageDic.allKeys containsObject:targetId]) {
//        NSArray * msgs = _messageDic[targetId];
//        if ([msgs isKindOfClass:[NSArray class]]) {
//            messages = msgs;
//        }
//    }
//
    [[DBTool share]getMessagesWithTarget:targetId success:^(NSArray *result) {
        if (success) {
            success(result);
        }
    }];
  
    
    
//    return messages;
}
-(void)addMsg:(MsgModel *)msg toTarget:(ConversationModel *)target{
    
    [[DBTool share]addModel:msg withTarget:target.Id response:^(BOOL success) {
        
    }];

    ConversationModel * targetModel = target;
    [self addConversationModel:targetModel response:^(BOOL success) {
        
    }];
    
//    [self getMessagesWithTargetId:targetId success:^(NSArray * result) {
//        
////        NSMutableArray * messages = [NSMutableArray arrayWithArray:result];
////        [messages addObject:msg];
////        [self->_messageDic setObject:messages forKey:targetId];
//        
//        [[DBTool share]addModel:msg withTarget:targetId response:^(BOOL success) {
//            
//        }];
//    }];

}

#pragma mark -- 处理 socket 收到的数据
-(void)handleMewMsg{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMewMessageWithNoti:) name:NotiForReceive object:nil];
}
-(void)handleMewMessageWithNoti:(NSNotification *)noti{
    
    
}
@end
