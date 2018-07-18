//
//  MyFriendsGroupModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFriendsModel.h"

@interface MyFriendsGroupModel : NSObject
@property (nonatomic,assign)BOOL Expanded;
@property (nonatomic,strong)NSString * Dicationary;
@property (nonatomic,strong)NSArray  * Friend;
@end
