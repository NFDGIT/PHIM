//
//  ContacksViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ContactsViewController.h"
#import "PHSegmentViewController.h"


#import "ContactsListViewController.h"
#import "MyFriendsViewController.h"
#import "MyGroupChatViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
    // Do any additional setup after loading the view.
}
-(void)initUI{

    ContactsListViewController * contactList = [ContactsListViewController new];
    contactList.hiddeNavi = YES;
    contactList.title = @"组织架构";
    
    MyFriendsViewController * myfriend = [MyFriendsViewController new];
    myfriend.hiddeNavi = YES;
    myfriend.title = @"好友";
    
    MyGroupChatViewController * mygroup = [MyGroupChatViewController new];
    mygroup.hiddeNavi = YES;
    mygroup.title = @"群聊";
    
    PHSegmentViewController * segment = [PHSegmentViewController new];
    segment.transitionStyle = UIPageViewControllerTransitionStyleScroll;
    [segment.controllers addObjectsFromArray:@[contactList,myfriend,mygroup]];
    [self addChildViewController:segment];
    [self.view addSubview:segment.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
