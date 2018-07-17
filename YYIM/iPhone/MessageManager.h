//
//  MessageManager.h
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgModel.h"
#import "MessageTargetModel.h"



@interface MessageManager : NSObject


+(instancetype)share;



-(NSArray<MessageTargetModel *> *)getMsgTargets;
-(void)addMsgTarget:(MessageTargetModel *)target;

-(NSArray<MsgModel *> *)getMessagesWithTargetId:(NSString *)targetId;
-(void)addMsg:(MsgModel *)msg toTarget:(NSString *)targetId;

#pragma mark -- 处理 socket 收到的数据
-(void)handleMewMsg;
@end
