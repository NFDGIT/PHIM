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


static PersonManager *shared = nil;


@interface PersonManager()

@property (nonatomic,strong)NSMutableDictionary<NSString *,UserInfoModel *> * dataDic;
@property (nonatomic,strong)NSMutableDictionary * myGroupChat;

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
    _dataDic = [NSMutableDictionary dictionary];
    [[DBTool share] getUserModels:^(NSDictionary * dataDic) {
        self->_dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    }];
    
}

-(void)updateModel:(UserInfoModel *)model{

    NSString * Id = [NSString stringWithFormat:@"%@",model.userID];
    UserInfoModel * lastModel = [UserInfoModel new];
    lastModel = model;
    [_dataDic setObject:model forKey:Id];

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
                [[NSNotificationCenter defaultCenter] postNotificationName:NotiForReceiveTypeUserInfoChange object:nil];
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
    
    
    
//    if (Id) {
//        <#statements#>
//    }
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


@end
