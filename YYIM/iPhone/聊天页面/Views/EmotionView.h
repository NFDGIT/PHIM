//
//  EmotionView.h
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmiliesTextAttachment.h"


@interface EmotionView : UIView
@property (nonatomic,strong)void(^clickBlock)(NSString * imgName);
@property (nonatomic,strong)void(^deleteBlock)();
@end
