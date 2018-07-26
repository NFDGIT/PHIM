//
//  ChatAddView.h
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,ChatAddType) {
    ChatAddTypeImage = 1,
};

@interface ChatAddView : UIView
@property (nonatomic,strong)void(^clickBlock)(ChatAddType type,id data);
@end
