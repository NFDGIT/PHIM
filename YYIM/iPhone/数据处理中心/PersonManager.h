//
//  PersonManager.h
//  YYIM
//
//  Created by Jobs on 2018/7/19.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PersonStatusModel.h"
#import "UserInfoModel.h"
#import "GroupChatModel.h"


@interface PersonManager : NSObject
@property (nonatomic,strong)NSMutableDictionary<NSString *,UserInfoModel *> * dataDic;
@property (nonatomic,strong)NSMutableDictionary<NSString *,GroupChatModel *> * groupChatDic;

+(instancetype)share;

-(void)updateModel:(UserInfoModel *)model;
-(UserInfoModel *)getModelWithId:(NSString *)Id;



-(void)setStatus:(NSString *)UserStatus withId:(NSString *)Id;
-(NSString *)getStatusWithId:(NSString *)Id;
-(void)refreshLocalPersons;


#pragma mark -- 群聊
-(void)refreshGroupChats;
-(void)updateGroupChatModel:(GroupChatModel *)groupChatModel;
-(GroupChatModel *)getGroupChatModelWithGroupId:(NSString *)groupId;
#pragma mark -- 我的好友
-(void)refreshMyFriends:(void(^)(BOOL success))response;
-(NSMutableArray*)getMyFriends;
-(BOOL)isMyFriend:(NSString *)Id;
@end
