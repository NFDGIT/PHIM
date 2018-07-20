//
//  UserChangeStatus.h
//  YYIM
//
//  Created by Jobs on 2018/7/20.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserChangeStatus : UIView
@property (nonatomic,assign)UserStatus userStatus;
@property (nonatomic,strong)void(^changeStatusBlock)(UserStatus userStatus);
-(void)appear;
-(void)disAppear;

@end
