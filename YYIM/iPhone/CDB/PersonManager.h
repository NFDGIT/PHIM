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


@interface PersonManager : NSObject
+(instancetype)share;

-(void)updateModel:(UserInfoModel *)model;
-(UserInfoModel *)getModelWithId:(NSString *)Id;



-(void)setStatus:(NSString *)UserStatus withId:(NSString *)Id;
-(NSString *)getStatusWithId:(NSString *)Id;
@end
