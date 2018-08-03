//
//  SocketTool.h
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//
#import "Define.h"

#import <Foundation/Foundation.h>

@interface SocketTool : NSObject

+ (SocketTool *)share;

/**
 开始心跳包
 */
-(void)startHeartBeat;
-(void)stopHeartBeat;
-(void)sendMsg:(NSString *)msg receiveId:(NSString *)receiveId msgInfoClass:(InformationType)msgInfoClass isGroup:(BOOL)isGroup;
/**
 发送socket
 
 @param MsgContent 发送的内容
 @param receiveId 发送给谁
 @param msgInfoClass 消息的类型
 @param isGroup 是不是群聊
 */
-(void)sendMsgContent:(NSString *)MsgContent receiveId:(NSString *)receiveId  msgInfoClass:(InformationType)msgInfoClass isGroup:(BOOL)isGroup;
@end
