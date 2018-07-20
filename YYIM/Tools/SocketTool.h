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
@end
