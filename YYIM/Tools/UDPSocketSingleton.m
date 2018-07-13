//
//  UDPSocketSingleton.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "UDPSocketSingleton.h"
#import "NSString+Json.h"
#import "NSData+GZip.h"
#import "NSString+Base64.h"

static UDPSocketSingleton *sharedInstance = nil;
@implementation UDPSocketSingleton

+ (UDPSocketSingleton *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        sharedInstance = [[self alloc] init];
        
        sharedInstance.socketHost = @"10.120.35.64";
        sharedInstance.socketPort = 5540;
    });

    return sharedInstance;

}









#pragma mark - 连接host
- (void)socketConnectHost {

    
    
    /**
     *  初始化
     */
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.socket.delegate = self;

    NSError *error = nil;
    /**
     *  所连接的服务器ip地址 socketHost 和 端口号:socketPort
     */
    BOOL isConnect =  [self.socket connectToHost:self.socketHost onPort:self.socketPort error:&error];
    if (isConnect) {
        /**
         *  允许广播信息
         */
        [self.socket enableBroadcast:YES error:&error];
        //启动接收线程
        
        //    [self.socket receiveWithTimeout:-1 tag:1];
        [self sendMessage];
        [self startTimer];
        
        
        
    }else{
        
        NSLog(@"socket %@ : %hu  连接失败",self.socketHost,self.socketPort);
    }
    
    




}

-(void)startTimer{
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

#pragma mark - 心跳包调用方法
- (void)longConnectToSocket {
    //    NSLog(@"心跳包信息发送");
    [self sendMessage];
}




#pragma mark - AsyncUDPSocketDelegate
#pragma mark 信息发送成功成功回调
/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    NSLog(@"已连接socket ：%@ -- %@:%hu",address,self.socketHost,self.socketPort);
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error{
        NSLog(@"不能连接socket ：%@",error);
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
        NSLog(@"已发送消息tag = %ld",tag);
    if (_sendBlock) {
        _sendBlock(tag,nil);
    }
}
 
/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error{
    //无法发送时,返回的异常提示信息  do something
    NSLog(@"不能发送消息tag:%ld ----- error :%@",tag,error);
    if (_sendBlock) {
        _sendBlock(tag,error);
    }
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    //    NSLog(@"接收到消息");
    
    
    if (data.length < 5) {
        
//        return NO;
    }
    
    /**
     *  解析数据
     */
    [self dataToString:data];
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error{
    NSLog(@"断开连接  error： %@",error);
    [self socketConnectHost];
}


#pragma mark - 接收到数据进行回调
- (void)receiveData:(dataBlock)block {
    self.receiveData = block;
}

#pragma mark -- 发消息
-(void)sendMsg:(NSString *)msg MsgInfoClass:(NSString *)msgInfoClass block:(SendBlock)sendBlock{
    
    NSString * SendID = @"13383824275";
    NSString * ReceiveId = @"";
    NSString * MsgInfoClass = msgInfoClass;
    NSString * MsgContent = msg;
    NSString * MsgContentBase64 = [NSString encode:MsgContent];
    
    NSString * GroupMsg = @"";
    NSString * Type = @"mobile";
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:SendID forKey:@"SendID"];
    [param setValue:ReceiveId forKey:@"ReceiveId"];
    [param setValue:MsgInfoClass forKey:@"MsgInfoClass"];
    [param setValue:MsgContentBase64 forKey:@"MsgContent"];
    [param setValue:GroupMsg forKey:@"GroupMsg"];
    [param setValue:Type forKey:@"Type"];
    
    
    NSString * jsonString =   [NSString convertToJsonData:param];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //    [self.socket receiveWithTimeout:-1 tag:1];
    
    /**
     *  获取通过Keychain保存的唯一不可变的UUID，否则UUID在删除程序重新装入后会变化
     */
    //    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    
    
    
    
    Byte *byte = (Byte *)[jsonData bytes];
    
    
    
    NSMutableData *writer=[[NSMutableData alloc]init];
    //        NSLog(@"%@",uuidStr);
    //    [writer appendData:jsonData];
    [writer appendBytes:byte length:sizeof(byte)];
    
    
    
    [self.socket sendData:writer withTimeout:-1 tag:2];
    _sendBlock = sendBlock;
}


#pragma mark -- 心跳包消息
- (void)sendMessage {

    NSString * SendID = @"13383824275";
    NSString * ReceiveId = @"";
    NSString * MsgInfoClass = @"82";
    NSString * MsgContent = @"心跳包";
    NSString * MsgContentBase64 = [NSString encode:MsgContent];
    
    NSString * GroupMsg = @"";
    NSString * Type = @"mobile";
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:SendID forKey:@"SendID"];
    [param setValue:ReceiveId forKey:@"ReceiveId"];
    [param setValue:MsgInfoClass forKey:@"MsgInfoClass"];
    [param setValue:MsgContentBase64 forKey:@"MsgContent"];
    [param setValue:GroupMsg forKey:@"GroupMsg"];
    [param setValue:Type forKey:@"Type"];
    
    NSString * jsonString =   [NSString convertToJsonData:param];
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    

//    [self.socket receiveWithTimeout:-1 tag:1];
    
    Byte *byte = (Byte *)[jsonData bytes];
    
    NSMutableData *writer=[[NSMutableData alloc]init];

    [writer appendBytes:byte length:sizeof(byte)];
    [self.socket sendData:writer  withTimeout:-1 tag:1];
    
}


#pragma mark - 数据解析

- (void)dataToString:(NSData *)data {


    //已经处理完毕
    int responseBytes = 32;
    [data getBytes:&responseBytes range:NSMakeRange(2, 1)];

    //    NSLog(@"\n\n----------------------接收信息：%d------------------\n\n",responseBytes);


    /**
     *  根据服务器返回的字节流的第3字节判断服务器信息，并给服务器返回响应数据，告知服务器已接收到信息并停止发送重复数据，否则服务器将持续不简单的发送数据
     */
    if (responseBytes == 16) {
        /**
         *  字节流数据解析，从第5个字节开始解析
         */
        //        int responseLength;
        //        [data getBytes:&responseLength range:NSMakeRange(4, 1)];
        //        NSData *strData = [data subdataWithRange:NSMakeRange(5, responseLength)];
        //        NSString *string = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        //        NSLog(@"response16 == %d, %@",responseLength, string);


        NSMutableData *writer=[[NSMutableData alloc]init];
//        NSString *uuidStr = [SSKeychain passwordForService:@"com.ilincar.ilincar" account:@"ilincar"];
        NSString *uuidStr = @"123456";

        int version = 1;
        int num = 1;
        int cmd = 16;
        int length = 0000;

        //uuid 进行MD5加密
        NSData *UUIDData = [uuidStr dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byte = (Byte *)[UUIDData bytes];
        Byte UUIDByte[16];
        CC_MD5(byte, (int)UUIDData.length, UUIDByte);//md5  加密


        [writer appendBytes:&version length:1];
        [writer appendBytes:&num length:1];
        [writer appendBytes:&cmd length:1];
        [writer appendBytes:UUIDByte length:16];
        [writer appendBytes:&length length:2];


//        [self.socket receiveWithTimeout:-1 tag:1];

        [self.socket sendData:writer withTimeout:-1 tag:1];



    } else if (responseBytes == 17) {

        /**
         *  字节流数据解析，从第5个字节开始解析
         */
        //        int responseLength;
        //        [data getBytes:&responseLength range:NSMakeRange(4, 1)];
        //        NSData *strData = [data subdataWithRange:NSMakeRange(5, responseLength)];
        //        NSString *string = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        //        NSLog(@"response17 == %d, %@",responseLength, string);


        NSMutableData *writer=[[NSMutableData alloc]init];
//        NSString *uuidStr = [SSKeychain passwordForService:@"com.ilincar.ilincar" account:@"ilincar"];
        NSString *uuidStr = @"123456";

        int version = 1;
        int num = 1;
        int cmd = 17;
        int aaa = 0;
        int bbb = 8;

        //uuid 进行MD5加密
        NSData *UUIDData = [uuidStr dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byte = (Byte *)[UUIDData bytes];
        Byte UUIDByte[16];
        CC_MD5(byte, (int)UUIDData.length, UUIDByte);//md5  加密

        //服务器所需的指定尾部字节需求
        Byte *lastByte = (Byte *)[[data subdataWithRange:NSMakeRange(5, 8)] bytes];

        [writer appendBytes:&version length:1];
        [writer appendBytes:&num length:1];
        [writer appendBytes:&cmd length:1];
        [writer appendBytes:UUIDByte length:16];
        [writer appendBytes:&aaa length:1];
        [writer appendBytes:&bbb length:1];
        [writer appendBytes:lastByte length:8];


//        [self.socket receiveWithTimeout:-1 tag:1];

        [self.socket sendData:writer withTimeout:-1 tag:1];


    } else if (responseBytes == 32) {

        /**
         *  字节流数据解析，从第5个字节开始解析
         */
        int responseLength;
        [data getBytes:&responseLength range:NSMakeRange(4, 1)];//获取所取范围的字节流的长度
        NSData *strData = [data subdataWithRange:NSMakeRange(5, responseLength)];
        NSString *string = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:nil];

        //        NSLog(@"UDPrespond32 = str:%@",string);


        NSDictionary *orderDic = [dic valueForKey:@"order"];
        NSString *code = [orderDic valueForKey:@"code"];

        if ([code isEqualToString:@"003"]) {

            NSUserDefaults *userDfaults = [NSUserDefaults standardUserDefaults];

            [userDfaults removeObjectForKey:@"account"];
            [userDfaults removeObjectForKey:@"bindState"];

//            [UIAppDelegate goToLoginView];
        }

#pragma mark - 将结果回调给主页面
        if (self.receiveData != nil) {
            self.receiveData(dic, string);
        }

        self.socketResult = [[NSDictionary alloc] initWithDictionary:dic];

        NSMutableData *writer=[[NSMutableData alloc]init];
//        NSString *uuidStr = [SSKeychain passwordForService:@"com.ilincar.ilincar" account:@"ilincar"];
        NSString *uuidStr = @"123456";

        int version = 1;
        int num = 1;
        int cmd = 32;
        int length = 0000;

        //uuid 进行MD5加密
        NSData *UUIDData = [uuidStr dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byte = (Byte *)[UUIDData bytes];
        Byte UUIDByte[16];
        CC_MD5(byte, (int)UUIDData.length, UUIDByte);//md5加密

        [writer appendBytes:&version length:1];
        [writer appendBytes:&num length:1];
        [writer appendBytes:&cmd length:1];
        [writer appendBytes:UUIDByte length:16];
        [writer appendBytes:&length length:2];

//        [self.socket receiveWithTimeout:-1 tag:1];

        [self.socket sendData:writer withTimeout:-1 tag:1];

    }

}

#pragma mark --断开连接
-(void)cutOffSocket {

    [self.socket close];
}
@end
