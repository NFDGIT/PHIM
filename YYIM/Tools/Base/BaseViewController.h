//
//  BaseViewController.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong)void(^userStatusChangeBlock)(NSDictionary * data);// 当有用户的状态发生改变时 的回调
@property (nonatomic,strong)void(^userInfoChangeBlock)(NSDictionary * data);// 当有用户的资料发生改变时 的回调
@property (nonatomic,strong)void(^chatNewMessageBlock)(NSDictionary * data);

@property (nonatomic,assign)BOOL hiddeNavi;
-(void)initNavi;
-(void)initData;
-(void)initUI;
-(void)refreshData;
-(void)refreshUI;
@end
