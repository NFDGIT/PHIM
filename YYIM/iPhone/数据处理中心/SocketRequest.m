//
//  SocketRequest.m
//  YYIM
//
//  Created by Jobs on 2018/7/27.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "SocketRequest.h"
#import "HandleSocketDao.h"
#import "NSString+Json.h"

@implementation SocketRequest
/**
 登录
 */
+(void)login{
        [[SocketTool share] sendMsg:@"1" receiveId:CurrentUserId msgInfoClass:InformationTypeUpdateSelfState isGroup:NO];
}
/**
 退出登录
 */
+(void)logout{
        [[SocketTool share]sendMsg:@"" receiveId:@""   msgInfoClass:InformationTypeSingOut isGroup:NO];
    
}
/**
 请求离线消息
 */
+(void)getOffLineMessage{
    [[SocketTool share]sendMsgContent:@"" receiveId:@"" msgInfoClass:InformationTypeGetOfflineMessage isGroup:NO];
    
}
/**
 发送文本消息
 
 @param msg 消息文本
 @param receiveId 接收ID
 */
+(void)sendMsg:(NSString *)msg receiveId:(NSString *)receiveId{
    [[SocketTool share]sendMsg:msg receiveId:receiveId msgInfoClass:InformationTypeChat isGroup:NO];
}
/**
 发送图片
 
 @param imgUrl 图片的内容
 @param receiveId 接收ID
 */
+(void)sendPhoto:(NSString *)imgUrl receiceId:(NSString *)receiveId{
    
    NSString * MsgContent =  [HandleSocketDao getBase64WithDictionary:@{@"ImageInfo":imgUrl,
                                                                        @"IsFileChat":@(NO),
                                                                        @"MsgContent":@"",
                                                                        }];
    [[SocketTool share]sendMsgContent:MsgContent receiveId:receiveId msgInfoClass:InformationTypeChatPhoto isGroup:NO];
    
}

/**
 发送文件
 
 @param fileName 文件的名称
 @param fileDesc 文件的描述
@param fileSize 文件的大小
 */
+(void)sendFileName:(NSString *)fileName fileDesc:(NSString *)fileDesc fileSize:(NSString *)fileSize receiceId:(NSString *)receiveId{
    
    
    NSDictionary * classinfo = @{
                                 @"fileSize":fileSize,
                                 @"pSendPos":@(0),
                                 @"identification":fileName,
                                 @"fileName":fileDesc
                                 };
    NSString * classinfojson = [NSString convertToJsonData:classinfo];
    
    

    NSString * MsgContent =  [HandleSocketDao getBase64WithDictionary:@{@"ImageInfo":@"",
                                                                        @"IsFileChat":@(YES),
                                                                        @"MsgContent":classinfojson,
                                                                        }];
    [[SocketTool share]sendMsgContent:MsgContent receiveId:receiveId msgInfoClass:InformationTypeChatFile isGroup:NO];
    
    
}
/**
 发送群文本消息
 
 @param msg 消息文本
 @param receiveId 接收ID
 */
+(void)sendGroupMsg:(NSString *)msg receiveId:(NSString *)receiveId{
    NSMutableDictionary * ClassTextMsg = [NSMutableDictionary dictionary];
    [ClassTextMsg setValue:msg forKey:@"MsgContent"];
    [ClassTextMsg setValue:@"" forKey:@"ImageInfo"];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:[HandleSocketDao getBase64WithDictionary:ClassTextMsg] forKey:@"ClassTextMsg"];
    
    NSString * msgContent = [HandleSocketDao getBase64WithDictionary:ClassTextMsg];
    

    [[SocketTool share] sendMsgContent:msgContent receiveId:receiveId msgInfoClass:InformationTypeBroadcastChat isGroup:YES];
    
}
/**
 发送群图片
 
 @param imgUrl 图片的内容
 @param receiveId 接收ID
 */
+(void)sendGroupPhoto:(NSString *)imgUrl receiceId:(NSString *)receiveId{
    
    NSString * MsgContent =  [HandleSocketDao getBase64WithDictionary:@{@"ImageInfo":imgUrl,
                                                                        @"IsFileChat":@(NO),
                                                                        @"MsgContent":@"",
                                                                        }];
    [[SocketTool share]sendMsgContent:MsgContent receiveId:receiveId msgInfoClass:InformationTypeChatPhoto isGroup:YES];
}
/**
 发送群文件消息
 
 @param fileName 文件名称
 @param fileDesc 文件描述
 @param fileSize 文件大小
 @param receiveId 接收方
 */
+(void)sendGroupFileName:(NSString *)fileName fileDesc:(NSString *)fileDesc fileSize:(NSString *)fileSize receiceId:(NSString *)receiveId{
    

    NSDictionary * classinfo = @{
                                 @"fileSize":fileSize,
                                 @"pSendPos":@(0),
                                 @"identification":fileName,
                                 @"fileName":fileDesc
                                 };
    NSString * classinfojson = [NSString convertToJsonData:classinfo];
    

    NSString * MsgContent =  [HandleSocketDao getBase64WithDictionary:@{@"ImageInfo":@"",
                                                                        @"IsFileChat":@(YES),
                                                                        @"MsgContent":classinfojson,
                                                                        }];
    [[SocketTool share]sendMsgContent:MsgContent receiveId:receiveId msgInfoClass:InformationTypeChatFile isGroup:YES];
}
@end
