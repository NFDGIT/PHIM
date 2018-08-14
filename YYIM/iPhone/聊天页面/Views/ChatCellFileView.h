//
//  ChatCellFileView.h
//  YYIM
//
//  Created by Jobs on 2018/8/1.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface ChatCellFileView : UIView
@property (nonatomic,strong)MsgModel  * model;
@property (nonatomic,strong)void(^clickBlock)();

@end
