//
//  ChatInputView.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatInputView : UIView
@property (nonatomic,strong)void(^inputBlock)(NSString * value);
@end
