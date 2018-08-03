//
//  GroupChatModel.h
//  YYIM
//
//  Created by Jobs on 2018/8/3.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFriendsModel.h"

@interface GroupChatModel : NSObject
@property (nonatomic,strong)NSString * groupDep; // 群描述
@property (nonatomic,strong)NSString * groupID; // 群ID
@property (nonatomic,strong)NSString * groupName; // 群名称
@property (nonatomic,strong)NSArray<MyFriendsModel *>  * memberList;
@end
