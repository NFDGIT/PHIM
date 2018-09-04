//
//  PersonManager.m
//  YYIM
//
//  Created by Jobs on 2018/7/19.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PersonManager.h"
#import "DBTool.h"
#import "MyGroupChatModel.h"
#import "MyFriendsModel.h"
#import "ProgressTool.h"


static PersonManager *shared = nil;


@interface PersonManager()


@property (nonatomic,strong)NSMutableDictionary * myGroupChat;
@property (nonatomic,strong)NSMutableArray * myFriends;

@end
@implementation PersonManager
+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [PersonManager new];
        [shared initData];
    });
    
    return shared;
}
-(void)initData{
    _myFriends = [NSMutableArray array];
    _dataDic = [NSMutableDictionary dictionary];
    _groupChatDic = [NSMutableDictionary dictionary];
    [[DBTool share] getUserModels:^(NSDictionary * dataDic) {
        self->_dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    }];
    if (MyFriends && [MyFriends isKindOfClass:[NSArray class]]) {
        _myFriends = [NSMutableArray arrayWithArray:MyFriends];
    }
}

-(void)updateModel:(UserInfoModel *)model{

    NSString * Id = [NSString stringWithFormat:@"%@",model.userID];
    UserInfoModel * lastModel = [UserInfoModel new];
    lastModel = model;
    [_dataDic setObject:model forKey:Id];

//    [[DBTool share] updateUserModel:model response:^(BOOL success) {
//        if (success) {
//
//        }else{
//            [[DBTool share] addUserModel:model response:^(BOOL success) {
//            }];
//
//        }
//    }];
    
//
    [[DBTool share] addUserModel:model response:^(BOOL success) {
    }];
}
-(UserInfoModel *)getModelWithId:(NSString *)Id{
   
    UserInfoModel * model = [UserInfoModel new];
    model.userID = Id;
    
    if ([_dataDic.allKeys containsObject:Id]) {
        model = _dataDic[Id];
    }else{
        
        // 当本地 没有数据时 就从网络请求 并且保存在本地
        [self getUserInfoWithId:Id response:^(BOOL success) {
            if (success) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserInfoChange object:nil];
            }
        }];
        
    }
      return model;
}

-(void)setStatus:(NSString *)UserStatus withId:(NSString *)Id{
    UserInfoModel * model = [self getModelWithId:Id];
    model.UserStatus = UserStatus;
    [self updateModel:model];
    
    
}
-(NSString *)getStatusWithId:(NSString *)Id{
   UserInfoModel * model = [self getModelWithId:Id];
    if (!model) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%@",model.UserStatus];
}

#pragma mark -- 网络请求数据
-(void)getUserInfoWithId:(NSString *)Id response:(void(^)(BOOL success))response{
    [Request getUserInfo1WithIdOrName:Id success:^(NSUInteger code, NSString *msg, id data) {
        if (code == 200) {
            UserInfoModel * model = [UserInfoModel new];
            [model setValuesForKeysWithDictionary:data];
            [self updateModel:model];
            response(YES);
        }else{
            response(NO);
        }
    } failure:^(NSError *error) {
        response(NO);
    }];
}
-(void)getMyGroupChatsWithId:(NSString *)Id response:(void(^)(BOOL success))response{
    
    

    NSString * userName =  CurrentUserId;
    
    [ProgressTool show];
    [Request getUserInfoWithIdOrName:userName success:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];
        
        if (code == 200) {
            //                NSArray * data = dataDic[@"Groups"];
            NSString * dataString =[NSString stringWithFormat:@"%@",data[@"Groups"]];
            NSArray * datas =   [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            
            
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dic in datas) {
                MyGroupChatModel * model = [MyGroupChatModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
            }
//            [self->_datas removeAllObjects];
//            [self->_datas addObjectsFromArray:arr];
            
        
        }
    } failure:^(NSError *error) {
        [ProgressTool hidden];
      
    }];
}

-(void)refreshLocalPersons{

    [Request getUserListSuccess:^(NSUInteger code, NSString *msg, id data) {
        if (code == 200) {
            NSMutableArray * persons = [NSMutableArray array];
            NSArray  *  nodes1 = [NSArray arrayWithArray:data];
            
            
            for (int x =0 ; x < nodes1.count ; x ++ ) {
                NSDictionary * node1 = nodes1[x];
                NSArray  *  nodes2 = [NSArray arrayWithArray:node1[@"Nodes"]];
                if ([node1.allKeys containsObject:@"UserInfo"] && nodes2.count<=0) {
                    [persons addObject:node1[@"UserInfo"]];
                }
                
                
                
                for (int y =0 ; y < nodes2.count ; y ++ ) {
                    NSDictionary * node2 = nodes2[y];
                    NSArray  *  nodes3 = [NSArray arrayWithArray:node2[@"Nodes"]];
                    if ([node2.allKeys containsObject:@"UserInfo"]&& nodes3.count<=0) {
                        [persons addObject:node2[@"UserInfo"]];
                    }
                    
                    
                    for (int z =0 ; z < nodes3.count ; z ++ ) {
                        NSDictionary * node3 = nodes3[z];
                        NSArray  *  nodes4 = [NSArray arrayWithArray:node3[@"Nodes"]];
                        if ([node3.allKeys containsObject:@"UserInfo"]&& nodes4.count<=0) {
                            [persons addObject:node3[@"UserInfo"]];
                        }
                        
                        
                        
                        for (int w =0 ; w < nodes4.count ; w ++ ) {
                            NSDictionary * node4 = nodes4[w];
                            NSArray * nodes5 = [NSArray arrayWithArray:node4[@"Nodes"]];
                            if ([node4.allKeys containsObject:@"UserInfo"]&& nodes5.count<=0) {
                                [persons addObject:node4[@"UserInfo"]];
                            }
                        }
                        
                        
                        
                        
                        
                    }
                }
            }
            
            for (NSDictionary * infoDic in persons) {
                UserInfoModel * model = [UserInfoModel new];
                [model setValuesForKeysWithDictionary:infoDic];
                
                [[PersonManager share] updateModel:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserInfoChange object:nil];
        }else{
            
            
        }

    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark -- 群聊
-(void)refreshGroupChats{
    NSString * userName =  CurrentUserId;
    [Request getUserInfoWithIdOrName:userName success:^(NSUInteger code, NSString *msg, id data) {
        if (code == 200) {
            //                NSArray * data = dataDic[@"Groups"];
            NSString * dataString =[NSString stringWithFormat:@"%@",data[@"Groups"]];
            NSArray * datas =   [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dic in datas) {
                GroupChatModel * model = [GroupChatModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
                
                [self updateGroupChatModel:model];
            }
            

        }
    } failure:^(NSError *error) {
    }];
}
-(void)updateGroupChatModel:(GroupChatModel *)groupChatModel{
    [_groupChatDic setObject:groupChatModel forKey:groupChatModel.groupID];
}
-(GroupChatModel *)getGroupChatModelWithGroupId:(NSString *)groupId{
    GroupChatModel * model = _groupChatDic[groupId];
    return model;
}
#pragma mark -- 我的好友

-(void)refreshMyFriends:(void(^)(BOOL success))response{
    [Request getUserInfoWithIdOrName:CurrentUserId success:^(NSUInteger code, NSString *msg, id data) {
        if (code == 200) {
            [self->_myFriends removeAllObjects];
            NSString * dataString =[NSString stringWithFormat:@"%@",data[@"FriendDicationary"]];
            NSArray * datas =   [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            [self->_myFriends addObjectsFromArray:datas];
            if (response) {
                response(YES);
            }
        }else{
            if (response) {
                response(NO);
            }
        }
    } failure:^(NSError *error) {
        if (response) {
            response(NO);
        }
    }];
    
}

-(NSMutableArray*)getMyFriends{
    return  _myFriends;
}
-(void)addFriends:(NSArray *)friends{
    [_myFriends addObjectsFromArray:friends];
    [[NSUserDefaults standardUserDefaults] setObject:_myFriends forKey:@"myFriends"];
}
-(BOOL)isMyFriend:(NSString *)Id{
//    return YES;
    for (NSDictionary * dic in [self getMyFriends]) {
        NSArray * Friend = dic[@"Friend"];
        for (NSDictionary * friendDic in Friend) {
            NSString * userID = [NSString stringWithFormat:@"%@",friendDic[@"userID"]];
            if ([userID isEqualToString:Id]) {
                return YES;
            }
        }
    }
    return NO;
    
}
@end
