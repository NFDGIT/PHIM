//
//  ChatBottomView.h
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionView.h"
#import "ChatAddView.h"

@interface ChatBottomView : UIView
@property (nonatomic,assign)NSUInteger page;

@property (nonatomic,strong)EmotionView * emotionView;
@property (nonatomic,strong)ChatAddView * addView;
@end
