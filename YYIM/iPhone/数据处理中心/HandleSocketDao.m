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
#import "AppDelegate.h"
#import "PHPush.h"



@implementation HandleSocketDao
#pragma mark -- 根据  MsgInfoClass  发送通知
+(void)solveWith:(NSDictionary *)receiveDic{
    
    InformationType  MsgInfoClass = [[NSString stringWithFormat:@"%@",receiveDic[@"MsgInfoClass"]] integerValue];
    switch (MsgInfoClass) {
        case InformationTypeSingOut: // 0  有新的用户离线
            [self handlePersonStatus:receiveDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserStatusChange object:receiveDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeSingOut object:receiveDic userInfo:nil];
            break;
        case InformationTypeUpdateSelfState: // 2   更新当前用户在线状态
          
             [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUpdateSelfState object:receiveDic userInfo:nil];
            [PHAlert showWithTitle:@"提示" message:@"状态修改成功" block:^{
            }];
            break;
        case InformationTypeNewUserLogin: // 3 有新的用户登陆
            [self handlePersonStatus:receiveDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserStatusChange object:receiveDic userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeNewUserLogin object:receiveDic userInfo:nil];
            
            
            break;
        case InformationTypeReturnChatArrival: //6 联系人不在线
            [HandleSocketDao contactNotOnline:receiveDic];
//            [self handleLeaveOut:receiveDic];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserStatusChange object:receiveDic userInfo:nil];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeNewUserLogin object:receiveDic userInfo:nil];
            break;
        case InformationTypeChat: /// 12 个人发送的消息
            [HandleSocketDao handleChatMsgDic:receiveDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeChat object:receiveDic userInfo:nil];
            
            
            break;
        case InformationTypeVibration: //13     窗口抖动
            [HandleSocketDao handleVibration:receiveDic];
            break;
        case InformationTypeUsersDataArrival: /// 收到用户部分联系人的资料 返回在线用户的数据
            [HandleSocketDao handleUsersDataArrival:receiveDic];
            break;
            

        case InformationTypeLeaveOut: //24  强制下线
            [self handleLeaveOut:receiveDic];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserStatusChange object:receiveDic userInfo:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeNewUserLogin object:receiveDic userInfo:nil];
            break;

        default:
            break;
    }
    
}

#pragma mark -- 聊天消息 的 处理

/**
 收到部分 联系人的资料

 @param msgDic 数据
 */
+(void)handleUsersDataArrival:(NSDictionary *)msgDic{
    NSDictionary * dataDic =[NSDictionary dictionaryWithDictionary:msgDic];
    
    if ([dataDic.allKeys containsObject:@"MsgContent"]) {
        NSString  * base64MsgContent =[NSString stringWithFormat:@"%@",dataDic[@"MsgContent"]];
        
        
    
        
        NSArray * baseArr = (NSArray *)[HandleSocketDao getDictionaryWithBase64:base64MsgContent];
        NSArray * List = [NSArray arrayWithArray:baseArr];
        
        for (NSDictionary * dic in List) {
            UserInfoModel * model = [UserInfoModel new];
            [model setValuesForKeysWithDictionary:dic];
            [[PersonManager share] setStatus:model.UserStatus withId:model.userID];
        };
        
        [PHAlert showWithTitle:@"接收类型为 4 MsgContent" message:List block:^{
        }];
        
        

//
    }
    
}

/**
 处理窗口抖动

 @param msgDic 数据
 */
+(void)handleVibration:(NSDictionary *)msgDic{
    [PHAlert showWithTitle:@"消息" message:@"窗口抖动" block:^{
    }];
}
/**
 用户状态发生改变

 @param msgDic 数据
 */
+(void)handlePersonStatus:(NSDictionary *)msgDic{
    NSDictionary * dataDic =[NSDictionary dictionaryWithDictionary:msgDic];
    
    NSString * SendID = [NSString stringWithFormat:@"%@",dataDic[@"SendID"]];
    
    
    if ([dataDic.allKeys containsObject:@"MsgContent"]) {
        
        NSDictionary * MsgContent = dataDic[@"MsgContent"];
        UserInfoModel * model = [UserInfoModel new];
        [model setValuesForKeysWithDictionary:MsgContent];
        
        [[PersonManager share]setStatus:model.UserStatus withId:model.userID]; //  只改变 状态值
        
        NSString *UserStatus = [NSString stringWithFormat:@"%@",model.UserStatus];
        [[PersonManager share]setStatus:model.UserStatus withId:model.userID];
        if ([model.userID isEqualToString:CurrentUserId]) {
            setCurrentUserStatus([model.UserStatus integerValue]);

        }

        if([UserStatus isEqualToString:@"0"])
        {
            [[PersonManager share]setStatus:@"0" withId:SendID];
        }
        [PHPush push:[NSString stringWithFormat:@"用户：%@ ，状态码：%@",model.userID,UserStatus]];
        [PHAlert showWithTitle:@"状态变化通知" message:[NSString stringWithFormat:@"用户：%@ ，状态码：%@",model.userID,UserStatus] block:^{
        }];
    }
    
}

/**
 强制下线

 @param msgDic 数据
 */
+(void)handleLeaveOut:(NSDictionary *)msgDic{
    [((AppDelegate *)[UIApplication sharedApplication].delegate) logout];
    [PHAlert showWithTitle:@"下线通知" message:@"您的账号在其他地方登陆" block:^{
        
    }];
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
            [PHPush push:[NSString stringWithFormat:@"%@",msg]];
        }
        
        
    }
    
}
+(void)contactNotOnline:(NSDictionary *)msgDic{
//    {
//        GroupMsg = 0;
//        MsgInfoClass = 6;
//        ReceiveId = 13383824275;
        NSString *   SendID = [NSString stringWithFormat:@"%@",msgDic[@"SendID"]];
//        Type = PC;
//    }
    UserInfoModel * model = [[PersonManager share]getModelWithId:SendID];
    NSString * name = model.userID;
    if (![model.userName isEmptyString]) {
        name = model.userName;
    }
    
    [PHAlert showWithTitle:@"提示" message:[NSString stringWithFormat:@"用户：%@ 不在线",name] block:^{
        
    }];
    
    
    
    
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


+(NSString *)getBase64WithObjc:(id)objc{
    NSString * jsonString = [NSString getJsonStringWithObjc:objc];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * dataGzip = [NSData gzipDeflate:jsonData];
    NSString * base64 = [dataGzip base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}
                       

@end
