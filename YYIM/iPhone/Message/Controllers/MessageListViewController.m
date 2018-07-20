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
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

-(void)initNavi{
    self.title = @"消息";
}
-(void)initData{
    _datas = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NotiForReceiveTypeChat object:nil];
    
    __weak typeof(self) weakSelf = self;
    self.userStatusChangeBlock = ^(NSDictionary *data) {
        [weakSelf refreshUI];
    };
    self.userInfoChangeBlock = ^(NSDictionary *data) {
        [weakSelf refreshUI];
    };
}
-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MessageLlistTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}

- (void)refreshData{
//    [[MessageManager share] getMsgTargetsSuccess:^(NSArray * result) {
//        self->_datas = [NSMutableArray arrayWithArray:result];
//
//        [self refreshUI];
//    }];
    [[MessageManager share]getConversations:^(NSArray * result) {
        self->_datas = [NSMutableArray arrayWithArray:result];
        
        [self refreshUI];
    }];
    
//
//    _datas =[NSMutableArray arrayWithArray:[[MessageManager share]getMsgTargets]];
//
//    [self refreshUI];
//    [Request searchUserWithIdOrName:@"15701344579" success:^(NSUInteger code, NSString *msg, id data) {
//
//    } failure:^(NSError *error) {
//
//    }];
    
}
-(void)refreshUI{
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
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


- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
