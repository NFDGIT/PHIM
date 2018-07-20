//
//  MessageTargetModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationModel : NSObject
@property (nonatomic,strong)NSString * Id;  // 聊天对象的 id
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * imgUrl;

@property (nonatomic,strong)NSString * lastMsg;
@property (nonatomic,assign)BOOL  GroupMsg;     // 是否是群聊
@end
