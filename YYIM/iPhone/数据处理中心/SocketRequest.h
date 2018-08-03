//
//  SocketRequest.h
//  YYIM
//
//  Created by Jobs on 2018/7/27.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketTool.h"

@interface SocketRequest : NSObject
/**
 登录
 */
+(void)login;
/**
 退出登录
 */
+(void)logout;

/**
 请求离线消息
 */
+(void)getOffLineMessage;
/**
 发送文本消息

 @param msg 消息文本
 @param receiveId 接收ID
 */
+(void)sendMsg:(NSString *)msg receiveId:(NSString *)receiveId;
/**
 发送图片
 
 @param imgUrl 图片的内容
 @param receiveId 接收ID
 */
+(void)sendPhoto:(NSString *)imgUrl receiceId:(NSString *)receiveId;
/**
 发送文件
 
 @param fileName 文件的名称
 @param fileDesc 文件的描述
 @param fileSize 文件的大小
 */
+(void)sendFileName:(NSString *)fileName fileDesc:(NSString *)fileDesc fileSize:(NSString *)fileSize receiceId:(NSString *)receiveId;
/**
 发送群文本消息
 
 @param msg 消息文本
 @param receiveId 接收ID
 */
+(void)sendGroupMsg:(NSString *)msg receiveId:(NSString *)receiveId;

@end
