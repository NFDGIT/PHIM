//
//  MyFriendsGroupHeaderView.h
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriendsGroupModel.h"

@interface MyFriendsGroupHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong)MyFriendsGroupModel * model;
@property (nonatomic,assign)NSInteger section;
@property (nonatomic,strong)void(^clickBlock)(NSInteger section);
@end
