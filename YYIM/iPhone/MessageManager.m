//
//  MessageManager.m
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MessageManager.h"
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



-(NSArray<MessageTargetModel *> *)getMsgTargets{
    NSArray * msgTargets = [NSArray array];
    if (_messageTargets) {
        msgTargets = _messageTargets;
    }
    return msgTargets;
}

-(void)addMsgTarget:(MessageTargetModel *)target{
    NSArray * msgTargets = [NSArray arrayWithArray:[self getMsgTargets]];
    for (MessageTargetModel * currentTarget in msgTargets) {
        if (currentTarget.Id == target.Id) {
            [_messageTargets removeObject:currentTarget];
        }
    }
    [_messageTargets addObject:target];
}
-(NSArray<MsgModel *> *)getMessagesWithTargetId:(NSString *)targetId{
    NSArray * messages = [NSArray array];
    
    if ([_messageDic.allKeys containsObject:targetId]) {
        NSArray * msgs = _messageDic[targetId];
        if ([msgs isKindOfClass:[NSArray class]]) {
            messages = msgs;
        }
    }
    return messages;
}
-(void)addMsg:(MsgModel *)msg toTarget:(NSString *)targetId{
    NSMutableArray * messages = [NSMutableArray arrayWithArray:[self getMessagesWithTargetId:targetId]];
    [messages addObject:msg];
    [_messageDic setObject:messages forKey:targetId];
}

#pragma mark -- 处理 socket 收到的数据
-(void)handleMewMsg{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMewMessageWithNoti:) name:NotiForReceive object:nil];
}
-(void)handleMewMessageWithNoti:(NSNotification *)noti{
    
    
}
@end
