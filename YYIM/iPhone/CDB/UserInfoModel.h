//
//  UserInfoModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/20.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic,strong)NSString * userID; 
@property (nonatomic,strong)NSString * userName;
@property (nonatomic,strong)NSString * UnderWrite;
@property (nonatomic,strong)NSString * HeadName;
@property (nonatomic,strong)NSString * UserStatus;
@property (nonatomic,strong)NSString * RealName;

@property (nonatomic,strong)NSArray * FriendDicationary;
@property (nonatomic,strong)NSArray * Groups;
@end
