//
//  MsgModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,MsgType) {
    MsgTypeText  = 0,
    MsgTypeImage = 1,
    MsgTypeAudio = 2,
};


@interface MsgModel : NSObject

@property (nonatomic,strong)NSString * target;

@property (nonatomic,strong)NSString * sendId;
@property (nonatomic,strong)NSString * receivedId;
@property (nonatomic,strong)NSString * realName;
@property (nonatomic,strong)NSString * content;        //文本消息
@property (nonatomic,assign)MsgType  msgType;     //消息类型 0，文本 1,图片 2，语音
@property (nonatomic,strong)NSString * imageUrl;
@property (nonatomic,strong)NSString * headIcon;
@property (nonatomic,strong)NSString * time;  //时间
@property (nonatomic,strong)NSString * imageLocal;


@property (nonatomic,assign)BOOL      GroupMsg;     // 是否是群聊
@property (nonatomic,assign)InformationType  MsgInfoClass; // 消息的种类。
@end
