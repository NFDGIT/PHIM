//
//  TabBarController.m
//  PuJiYC
//
//  Created by penghui on 2018/1/30.
//  Copyright © 2018年 penghui. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"


#import "MessageListViewController.h"
#import "ContactsListViewController.h"
#import "ContactsViewController.h"
#import "MineViewController.h"



@interface TabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,strong)NSMutableArray * tabbarItems;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    
    // Do any additional setup after loading the view.
}
-(void)initData{
    
    
    _tabbarItems =  [NSMutableArray array];
    [_tabbarItems addObject:@{@"img":@"icon",@"title":@"消息",@"controller":NSStringFromClass([MessageListViewController class])}];
    [_tabbarItems addObject:@{@"img":@"icon",@"title":@"联系人",@"controller":NSStringFromClass([ContactsViewController class])}];
    [_tabbarItems addObject:@{@"img":@"icon",@"title":@"我的",@"controller":NSStringFromClass([MineViewController class])}];

    
}
-(void)initUI{
    self.delegate = self;
    NSMutableArray * vcs = [NSMutableArray array];
    for (int i =0 ; i < _tabbarItems.count; i ++) {
        NSDictionary * currentDic =_tabbarItems[i];
        
        NSString * img = [NSString stringWithFormat:@"%@",currentDic[@"img"]];
        NSString * title = [NSString stringWithFormat:@"%@",currentDic[@"title"]];
        NSString * controllerString = [NSString stringWithFormat:@"%@",currentDic[@"controller"]];
        
        Class Class = NSClassFromString(controllerString);
        BaseViewController * controller = [Class new];
//        controller.navigationItem.title = [NSString stringWithFormat:@"%d",i];
        if (i == 1) {
            controller.hiddeNavi = YES;
        }
        
        
        NavigationController * naviVC = [[NavigationController alloc]initWithRootViewController:controller];
        naviVC.tabBarItem.title = title;
        naviVC.tabBarItem.image = [UIImage imageNamed:img];
        
     
        
        [vcs addObject:naviVC];
    }
    
    self.tabBar.tintColor = [UIColor orangeColor];
    self.viewControllers =  vcs;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- delegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    

    return YES;
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

