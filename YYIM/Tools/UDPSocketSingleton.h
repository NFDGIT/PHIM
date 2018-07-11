//
//  UDPSocketSingleton.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GCDAsyncUdpSocket.h"
#import <GCDAsyncUdpSocket.h>
#import <CommonCrypto/CommonDigest.h>

typedef void (^dataBlock)(NSDictionary *response, NSString *responseString);


@interface UDPSocketSingleton : NSObject<GCDAsyncUdpSocketDelegate>


@property (nonatomic, strong) GCDAsyncUdpSocket *socket;   // socket
@property (nonatomic, copy) NSString *socketHost;       // socket的Host
@property (nonatomic, assign) UInt16 socketPort;        // socket的prot
@property (nonatomic, strong) NSTimer *connectTimer;    // 计时器
@property (nonatomic, strong) NSDictionary *socketResult;

@property (nonatomic, strong) dataBlock receiveData;

/**
 *  block回调方法，为了回调的时候少写代码
 */
- (void)receiveData:(dataBlock)block;

+ (UDPSocketSingleton *)sharedInstance;   // 单例

- (void)socketConnectHost;  // socket连接

-(void)cutOffSocket; // 断开socket连接

-(void)sendMsg:(NSString *)msg; // 发消息
@end
