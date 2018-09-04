//
//  NaviAddAlertView.h
//  YYIM
//
//  Created by Jobs on 2018/7/25.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviAddAlertView : UIView
@property (nonatomic,strong)void(^clickBlock)(NSUInteger index);
-(void)appear;
-(void)disAppear;

@end
