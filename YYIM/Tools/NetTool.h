//
//  NetTool.h
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetTool : NSObject
@property (atomic,assign)BOOL onLine;
+ (instancetype)share;

//获取host的名称
+ (NSString *) hostname;
//从host获取地址
+ (NSString *) getIPAddressForHost: (NSString *) theHost;
//这是本地host的IP地址
+ (NSString *) localIPAddress;
+(NSInteger)getNetPort;

// 检测网络
-(void)startDetection;
+(void)detectionNet;
-(void)detectionServer;
@end
