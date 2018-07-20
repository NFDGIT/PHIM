//
//  PersonDetailViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "ChatViewController.h"


@interface PersonDetailViewController ()

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initUI];
    [self refreshData];
    // Do any additional setup after loading the view.
}
-(void)initNavi{
    self.title = @"用户详情";
    
}
-(void)initUI{
    UIButton * btnMessage = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btnMessage setTitleColor:ColorBlack forState:UIControlStateNormal];
    btnMessage.titleLabel.font = FontBig;
    [btnMessage setTitle:@"发消息" forState:UIControlStateNormal];
    [self.view addSubview:btnMessage];
    [btnMessage addTarget:self action:@selector(jumpToChatVC) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)refreshData{
//    [Request getUserListSuccess:^(NSUInteger code, NSString *msg, id data) {
//
//    } failure:^(NSError *error) {
//
//    }];
//    [Request getFriendsWithIdOrName:@"" success:^(NSUInteger code, NSString *msg, id data) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
}
#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 点击事件
-(void)jumpToChatVC{
    if ([_Id isEmptyString]) {
        [self.view makeToast:@"Id 不存在" duration:2 position:CSToastPositionCenter];
        return;
    }
    
//    ChatViewController * chat = [ChatViewController new];
//    chat.userId = _Id;
//    [self.navigationController pushViewController:chat animated:YES];
    
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
