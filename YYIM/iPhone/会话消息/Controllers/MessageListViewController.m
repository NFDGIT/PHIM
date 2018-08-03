//
//  MessageListViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageLlistTableViewCell.h"
#import "ChatViewController.h"
#import "MessageManager.h"
#import "ConversationModel.h"
#import "NetTool.h"
#import "PersonCenterView.h"
#import "NaviAddAlertView.h"
#import "PHPush.h"
#import "PersonManager.h"
//
//#import "DBTool.h"

@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    [self refreshData];
    [self layout];
    if ([PersonManager share].dataDic.allKeys.count < 3) {
       [[PersonManager share]refreshLocalPersons];
    }
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
    [self layout];
    [PHPush refreshBage];
}

-(void)initNavi{
    self.title = @"消息";
    
    
    UIButton * headBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    headBtn.clipsToBounds = YES;
    headBtn.layer.masksToBounds = YES;
    headBtn.backgroundColor = ColorWhite;
    headBtn.layer.cornerRadius = headBtn.height/2;
    headBtn.contentMode = UIViewContentModeScaleAspectFill;
    [headBtn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40 , 40)];
    [headBtn addSubview:headImg];
    headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",CurrentUserIcon]];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:headBtn] animated:YES];

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnClick)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)initData{
    _datas = [NSMutableArray array];

    
    __weak typeof(self) weakSelf = self;
    self.loginSuccessBlock = ^{
        [weakSelf refreshData];
    };
    
    self.userStatusChangeBlock = ^(NSDictionary *data) {
        [weakSelf refreshUI];
    };
    self.userInfoChangeBlock = ^(NSDictionary *data) {
        [weakSelf refreshUI];
    };
    self.serverStateChangeBlock = ^(BOOL onLine) {
        [weakSelf layout];
    };
    self.chatNewMessageBlock = ^(NSDictionary *data) {
        [weakSelf refreshData];
    };
}
-(void)initUI{

    UILabel * notNetLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    notNetLabel.backgroundColor = ColorRed;
    notNetLabel.textColor = ColorWhite;
    notNetLabel.text = @"无法连接服务器";
    notNetLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:notNetLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MessageLlistTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}

- (void)refreshData{

    [[MessageManager share]getConversations:^(NSArray * result) {
        self->_datas = [NSMutableArray arrayWithArray:result];
        [self refreshUI];
    }];
    

}
-(void)refreshUI{
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    [self initNavi];
}
-(void)layout{

    [UIView animateWithDuration:1 animations:^{
        if (serverOnLine) {
            self.tableView.top = 0;
        }else{
            self.tableView.top = 40;
        }
    }];
}
#pragma mark -- delegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return  [tableView cellHeightWithIndexPath:indexPath];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConversationModel * model = _datas[_datas.count - 1 - indexPath.section];

    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[MessageManager share] deleteConversationId:model.Id response:^(BOOL success) {
            if (success) {
                [self refreshData];
            }
        }];
    }];
    
    return @[action];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageLlistTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    ConversationModel * model = _datas[_datas.count - 1 - indexPath.section];
    cell.model = model;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    ChatViewController * chatvc = [ChatViewController new];
    ConversationModel * target = _datas[_datas.count - 1 - indexPath.section];;

    chatvc.conversationModel = target;
    [self.navigationController pushViewController:chatvc animated:YES];
    
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- 点击事件
-(void)headClick{
    if ([PersonCenterView share].left == 0) {
        [[PersonCenterView share] disAppear];
    }else{
        [[PersonCenterView share] appear];
    }

    
}
-(void)addBtnClick{
    NaviAddAlertView * addView = [NaviAddAlertView new];
    [addView appear];
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
