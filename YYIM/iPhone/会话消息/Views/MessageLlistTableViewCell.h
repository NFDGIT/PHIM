//
//  MessageLlistTableViewCell.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationModel.h"
#import "PHCellHeight.h"

@interface MessageLlistTableViewCell : UITableViewCell
@property (nonatomic,strong)ConversationModel * model;
@end
