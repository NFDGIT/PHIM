//
//  BaseViewController.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,assign)BOOL hiddeNavi;
-(void)initNavi;
-(void)initData;
-(void)initUI;
-(void)refreshData;
-(void)refreshUI;
@end
