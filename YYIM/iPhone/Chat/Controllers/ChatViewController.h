//
//  ChatViewController.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageTargetModel.h"

@interface ChatViewController : BaseViewController
//@property (nonatomic,strong)NSString * userId;
@property (nonatomic,strong)MessageTargetModel * targetModel;
@end
