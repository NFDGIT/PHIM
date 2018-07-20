//
//  HandleSocketDao.m
//  YYIM
//
//  Created by Jobs on 2018/7/19.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "HandleSocketDao.h"
#import "MsgModel.h"
#import "ConversationModel.h"
#import "MessageManager.h"
#import "NSString+Json.h"
#import "NSString+Base64.h"
#import "NSData+GZip.h"
#import "PersonManager.h"




@implementation HandleSocketDao
#pragma mark -- 根据  MsgInfoClass  发送通知
+(void)solveWith:(NSDictionary *)receiveDic{
    
    InformationType  MsgInfoClass = [[NSString stringWithFormat:@"%@",receiveDic[@"MsgInfoClass"]] integerValue];
    switch (MsgInfoClass) {
        case InformationTypeChat: /// 个人发送的消息
            [HandleSocketDao handleChatMsgDic:receiveDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeChat object:receiveDic userInfo:nil];
            break;
        case InformationTypeSingOut: /// 有新的用户离线
            [self handlePersonStatus:receiveDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserStatusChange object:receiveDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeSingOut object:receiveDic userInfo:nil];
            break;
        case InformationTypeNewUserLogin: /// 有新的用户登陆
            [self handlePersonStatus:receiveDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserStatusChange object:receiveDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeNewUserLogin object:receiveDic userInfo:nil];
            break;
        default:
            break;
    }
    
}

#pragma mark -- 聊天消息 的 处理


/**
 用户状态发生改变

 @param msgDic 数据
 */
+(void)handlePersonStatus:(NSDictionary *)msgDic{
    NSDictionary * dataDic =[NSDictionary dictionaryWithDictionary:msgDic];
    
    if ([dataDic.allKeys containsObject:@"MsgContent"]) {
        
        NSDictionary * MsgContent = dataDic[@"MsgContent"];
        UserInfoModel * model = [UserInfoModel new];
        [model setValuesForKeysWithDictionary:MsgContent];
        
        [[PersonManager share]setStatus:model.UserStatus withId:model.userID]; //  只改变 状态值
        if (MsgContent.allKeys.count > 4) { // 判断如果 返回的数据比较多的话 就把这个用户的所有数据都更新
              [[PersonManager share]updateModel:model];
        }
        
    }
    
}

/**
 把聊天消息保存到单例中
 
 @param msgDic 接收的消息
 */
+(void)handleChatMsgDic:(NSDictionary *)msgDic{
    NSDictionary * MsgContent =[NSDictionary dictionaryWithDictionary:msgDic];
    InformationType  MsgInfoClass = [[NSString stringWithFormat:@"%@",MsgContent[@"MsgInfoClass"]] integerValue];
    NSString *  ReceiveId = [NSString stringWithFormat:@"%@",MsgContent[@"ReceiveId"]];
    NSString *  SendID = [NSString stringWithFormat:@"%@",MsgContent[@"SendID"]];
    BOOL        GroupMsg = [NSString stringWithFormat:@"%@",MsgContent[@"GroupMsg"]].boolValue;
    
    if (MsgInfoClass == InformationTypeChat && [ReceiveId isEqualToString:CurrentUserId]) {
        
        if (MsgContent && [MsgContent.allKeys containsObject:@"MsgContent"]) {
            
            NSString * msg = [NSString stringWithFormat:@"%@",MsgContent[@"MsgContent"][@"MsgContent"]];
            
            MsgModel * model = [MsgModel new];
            //            model.headIcon =
            model.target = SendID;
            model.sendId = SendID;
            model.receivedId = ReceiveId;
            model.content = msg;
            model.msgType = 0;
            model.MsgInfoClass = InformationTypeChat;
            model.GroupMsg = GroupMsg;
            
            
            ConversationModel * target = [ConversationModel new];
            target.Id = SendID;
            target.name = @"";
            target.imgUrl = @"";
            
            [[MessageManager share] addMsg:model toTarget:target];
        }
        
        
    }
    
}

#pragma mark -- 压缩 解压

+(NSData *)getGzipWithDictionary:(NSDictionary *)dictionary{
    NSString * jsonString =   [NSString convertToJsonData:dictionary];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * dataGzip = [NSData gzipDeflate:jsonData];
    return dataGzip;
}

+(NSDictionary *)getDictionaryWithGzip:(NSData *)GzipData{
    // 解压
    NSData * data2 = [NSData gzipInflate:GzipData];
    // data 转json 字符串
    NSString * jsonString = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSString dictionaryWithJsonString:jsonString];
    return dataDic;
}

+(NSString *)getBase64WithDictionary:(NSDictionary *)dictionary{
    NSData * dataGzip = [self getGzipWithDictionary:dictionary];
    NSString * base64 = [dataGzip base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}
+(NSDictionary *)getDictionaryWithBase64:(NSString*)base64{
    if ([base64 isKindOfClass:[NSNull class]]) {
        return [NSDictionary dictionary];
    };
    
    if ([base64 isEmptyString]) {
        return [NSDictionary dictionary];
    };
    
    // base64 转为 data
    NSData * gzipdata = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64Encoding64CharacterLineLength];
    return   [self getDictionaryWithGzip:gzipdata];
}


@end
