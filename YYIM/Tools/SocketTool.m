//
//  SocketTool.m
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "SocketTool.h"
#import <GCDAsyncUdpSocket.h>

#import "NSString+Json.h"
#import "NSString+Base64.h"
#import "NSData+GZip.h"
#import "NetTool.h"





static SocketTool *shared = nil;
@interface SocketTool()<GCDAsyncUdpSocketDelegate>


@property (nonatomic,strong)GCDAsyncUdpSocket * udpSocket;
@property (nonatomic,strong)NSTimer * connectTimer;


@property (nonatomic,strong)NSString * networkIP;
@property (nonatomic,assign)NSInteger  udpPort;
@property (nonatomic,assign)NSInteger  receivePort;

@end
@implementation SocketTool
+ (SocketTool *)share{
   
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared setupSocket];
    });
    
    return shared;
}

- (void)setupSocket

{
    _networkIP = @"10.120.35.64";
    _udpPort = 5540;
    
    //    创建Socket
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //  监听接口&接收数据
    NSError * error = nil;
    [_udpSocket bindToPort:_udpPort error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        [_udpSocket beginReceiving:&error];
    }
    
}
-(void)startHeartBeat{
    /**
     *  建立定时器，每隔50s像服务器发送心跳包
     *
     *  longConnectToSocket:心跳包调用方法，在longConnectToSocket方法中进行长连接，并向服务器发送的讯息
     *
     *  TimeInterval:心跳包执行间隔时间
     *
     */
    [self.connectTimer invalidate];
    self.connectTimer = nil;
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    /**
     *  启动定时器
     */
    [self.connectTimer fire];
}
-(void)longConnectToSocket{
    [self sendMsg:@"心跳包" receiveId:@"" msgInfoClass:82];

    
    
}


-(void)sendMsg:(NSString *)msg receiveId:(NSString *)receiveId  msgInfoClass:(NSInteger)msgInfoClass{
    NSString * SendID = CurrentUserId;
    NSString * ReceiveId = receiveId;
    NSInteger MsgInfoClass = msgInfoClass;
    
    
    
    
    
    NSString * MsgContent = [self getHeartBeatMsgContent]; // 心跳包
    if (msgInfoClass == 12) { // 消息
        MsgContent = [self getMsgContentWithMsg:msg];
    };
 
    
    
    
    BOOL  GroupMsg = NO;
    NSString * Type = @"mobile";

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:SendID forKey:@"SendID"];
    [param setValue:ReceiveId forKey:@"ReceiveId"];
    [param setValue:@(MsgInfoClass) forKey:@"MsgInfoClass"];
    [param setValue:MsgContent forKey:@"MsgContent"];
    [param setValue:@(GroupMsg) forKey:@"GroupMsg"];
    [param setValue:Type forKey:@"Type"];
    

    NSString * jsonString =   [NSString convertToJsonData:param];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * dataGzip = [NSData gzipDeflate:jsonData];
    
    [_udpSocket sendData:dataGzip toHost:_networkIP port:_udpPort withTimeout:-1 tag:msgInfoClass];
}






// 返回 字段的内容 MsgContent
-(NSString *)getMsgContentWithMsg:(NSString *)msg{
    NSMutableDictionary * ClassTextMsg = [NSMutableDictionary dictionary];
    [ClassTextMsg setValue:msg forKey:@"msg"];
    [ClassTextMsg setValue:@"" forKey:@"ImageInfo"];
    
    
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:[self getBase64WithDictionary:ClassTextMsg] forKey:@"ClassTextMsg"];

    return [self getBase64WithDictionary:param];
}
#pragma mark -- 心跳包的 msgcontent
-(NSString *)getHeartBeatMsgContent{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:@"13383824275" forKey:@"ClassUserInfo"];
    [param setValue:@"彭辉" forKey:@"RealName"];
    [param setValue:CurrentUserId forKey:@"UserId"];
    [param setValue:@"10.120.35.203" forKey:@"IP"];
    [param setValue:@([NetTool getNetPort]) forKey:@"Port"];
    [param setValue:@"" forKey:@"StateInfo"];
    [param setValue:@(1) forKey:@"State"];
    
    NSString * jsonString =   [NSString convertToJsonData:param];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * dataGzip = [NSData gzipDeflate:jsonData];
    
    NSString * base64 = [dataGzip base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return base64;
}



#pragma mark --- 代理方法
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功 tag:%ld",tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败 tag:%ld",tag);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSLog(@"接收到%@的消息:%@",address,data);//自行转换格式吧
    NSLog(@"%@",[self resolveReceiveDataWithData:data]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceive object:[self resolveReceiveDataWithData:data] userInfo:nil];
    
}
-(NSDictionary *)resolveReceiveDataWithData:(NSData *)data{
    NSData * inflateData =  [NSData gzipInflate:data];
    NSString * jsonString = [[NSString alloc] initWithData:inflateData encoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSString dictionaryWithJsonString:jsonString];
    
    
    if ([dataDic.allKeys containsObject:@"MsgContent"]) {
        NSDictionary * MsgContentDic = [self getDictionaryWithBase64:dataDic[@"MsgContent"]];
        if ([MsgContentDic.allKeys containsObject:@"ClassTextMsg"]) {
            NSDictionary * ClassTextMsgDic = [self getDictionaryWithBase64:MsgContentDic[@"ClassTextMsg"]];
            
            
            
            
            [MsgContentDic setValue:ClassTextMsgDic forKey:@"ClassTextMsg"];
        }
        
        
        
        
        [dataDic  setValue:MsgContentDic forKey:@"MsgContent"];
    }
    
    return dataDic;
}
#pragma mark -- 压缩 解压

-(NSData *)getGzipWithDictionary:(NSDictionary *)dictionary{
    NSString * jsonString =   [NSString convertToJsonData:dictionary];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * dataGzip = [NSData gzipDeflate:jsonData];
    return dataGzip;
}

-(NSDictionary *)getDictionaryWithGzip:(NSData *)GzipData{
    // 解压
    NSData * data2 = [NSData gzipInflate:GzipData];
    // data 转json 字符串
    NSString * jsonString = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSString dictionaryWithJsonString:jsonString];
    return dataDic;
}

-(NSString *)getBase64WithDictionary:(NSDictionary *)dictionary{
    NSData * dataGzip = [self getGzipWithDictionary:dictionary];
    NSString * base64 = [dataGzip base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}
-(NSDictionary *)getDictionaryWithBase64:(NSString*)base64{
    
    // base64 转为 data
    NSData * gzipdata = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64Encoding64CharacterLineLength];
    return   [self getDictionaryWithGzip:gzipdata];

}



@end
