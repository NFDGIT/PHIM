//
//  MsgModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel : NSObject
//@property (nonatomic,strong)NSString * msg;
//@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * sendId;
@property (nonatomic,strong)NSString * receivedId;
@property (nonatomic,strong)NSString * realName;
@property (nonatomic,strong)NSString * content;        //文本消息
@property (nonatomic,strong)NSString * msgType;     //消息类型
@property (nonatomic,strong)NSString * imageUrl;
@property (nonatomic,strong)NSString * headIcon;
@property (nonatomic,strong)NSString * time;  //时间
@property (nonatomic,strong)NSString * imageLocal;


@end
