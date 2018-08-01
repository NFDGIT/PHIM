//
//  ChatCell.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"
#import "PHCellHeight.h"

@interface ChatCell : UITableViewCell
+ (instancetype)share;
@property (nonatomic,strong)MsgModel * model;
@property (nonatomic,strong)void(^headClickBlock)(NSIndexPath * indexPath);

-(CGFloat)getHeightWithModel:(MsgModel *)model;
@end
