//
//  SocketTool.h
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketTool : NSObject
+ (SocketTool *)share;

/**
 开始心跳包
 */
-(void)startHeartBeat;
-(void)sendMsg:(NSString *)msg msgInfoClass:(NSInteger)msgInfoClass;
@end
