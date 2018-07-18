//
//  MyGroupChatModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFriendsModel.h"

@interface MyGroupChatModel : NSObject
@property (nonatomic,strong)NSString * groupID;
@property (nonatomic,strong)NSString * groupName;
@property (nonatomic,strong)NSString * groupDep;
@property (nonatomic,strong)NSArray<MyFriendsModel *>  * memberList;

@end
