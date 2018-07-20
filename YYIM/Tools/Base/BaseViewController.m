//
//  BaseViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = self.hiddeNavi;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChange:) name:NotiForReceiveTypeUserStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange:) name:NotiForReceiveTypeUserInfoChange object:nil];
    

    // Do any additional setup after loading the view.
}
-(void)initNavi{
}
-(void)initData{
}
-(void)initUI{
}
-(void)refreshData{
}
-(void)refreshUI{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)userStatusChange:(NSNotification *)noti{
    if (_userStatusChangeBlock) {
        _userStatusChangeBlock(noti.object);
    }
}
-(void)userInfoChange:(NSNotification *)noti{
    if (_userInfoChangeBlock) {
        _userInfoChangeBlock(noti.object);
    }
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
