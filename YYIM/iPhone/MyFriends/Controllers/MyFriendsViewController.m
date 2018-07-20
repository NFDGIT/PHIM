//
//  MyFriendsViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyFriendsViewController.h"

#import "MyFriendsGroupHeaderView.h"
#import "MyFriendTableViewCell.h"



#import "MyFriendsGroupModel.h"
#import "ChatViewController.h"
#import "PersonDetailViewController.h"

@interface MyFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation MyFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    [self refreshData];

    
    
    

    // Do any additional setup after loading the view.
}

-(void)initData{
    _datas = [NSMutableArray array];

    __weak typeof(self) weakSelf = self;
    self.userStatusChangeBlock = ^(NSDictionary *data) {
        [weakSelf refreshUI];
    };
}
-(void)initNavi{
    self.title = @"我的好友";
    
}
-(void)initUI{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MyFriendsGroupHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [_tableView registerClass:[MyFriendTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor  =[UIColor whiteColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}
-(void)refreshUI{
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
}


-(void)refreshData{
    
    NSDictionary * dataDic = @{
                               @"FriendDicationary":@[@{@"Dicationary":@"我的好友",@"Friend":@[@{@"userID":@"15904076020",@"userName":@"孙文",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"15"},@{@"userID":@"18516568515",@"userName":@"张志丹",@"UnderWrite":@"测试主管",@"HeadName":@"91"}]},
                                                      @{@"Dicationary":@"朋友",@"Friend":@[@{@"userID":@"15904076020",@"userName":@"孙文",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"15"},@{@"userID":@"18516568515",@"userName":@"张志丹",@"UnderWrite":@"测试主管",@"HeadName":@"91"}]}],
                               @"Groups": @[@{@"groupID":@"123",@"groupName":@"HELLO WORLD",@"groupDep":@"欢迎进入我的群！Q ！",@"memberList":@[@{@"userID":@"13522220187",@"userName":@"黄华东",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"66"},@{@"userID":@"15904076020",@"userName":@"孙文",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"15"},@{@"userID":@"18511961198",@"userName":@"江飞洋",@"UnderWrite":@"产品经理",@"HeadName":@"10"},@{@"userID":@"18516568515",@"userName":@"张志丹",@"UnderWrite":@"测试主管",@"HeadName":@"91"}]}],
                               @"userID":@"13522220187",
                               @"userName":@"黄华东",
                               @"UnderWrite":@"阿发斯蒂芬",
                               @"HeadName":@"66"
                               };
    
    NSArray * data = dataDic[@"FriendDicationary"];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * dic in data) {
        MyFriendsGroupModel * model = [MyFriendsGroupModel new];
        [model setValuesForKeysWithDictionary:dic];
        [arr addObject:model];
    }
    [_datas removeAllObjects];
    [_datas addObjectsFromArray:arr];
    
    
    
    [self refreshUI];

    
    NSString * userName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
//    userName = @"15701344579";

    [ProgressTool show];
    [Request getUserInfoWithIdOrName:userName success:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];

        if (code == 200) {
            
            NSString * dataString =[NSString stringWithFormat:@"%@",data[@"FriendDicationary"]];
            NSArray * datas =   [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            
            
      
            
            NSMutableArray * arr = [NSMutableArray array];
            for (NSDictionary * dic in datas) {
                MyFriendsGroupModel * model = [MyFriendsGroupModel new];
                [model setValuesForKeysWithDictionary:dic];
                [arr addObject:model];
            }
            [self->_datas removeAllObjects];
            [self->_datas addObjectsFromArray:arr];
            
            
            [self refreshUI];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络请求失败" duration:2 position:CSToastPositionCenter];
        [ProgressTool hidden];
    }];
    
}

#pragma mark -- delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MyFriendsGroupModel * model = _datas[section];
    MyFriendsGroupHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.section = section;
    header.model = model;
    
    
    header.clickBlock = ^(NSInteger sectio) {
        MyFriendsGroupModel * selectModel = self->_datas[sectio];
        selectModel.Expanded = !selectModel.Expanded;
        [self->_datas replaceObjectAtIndex:sectio withObject:selectModel];
        [self refreshUI];
    };

    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MyFriendsGroupModel * groupModel = _datas[section];
    NSArray * friends = groupModel.Friend;
    if (!groupModel.Expanded) {
        return 0;
    }
    return friends.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightWithIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    MyFriendsGroupModel * groupModel = _datas[indexPath.section];
    NSArray * friends = groupModel.Friend;
    
    MyFriendsModel * model = friends[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFriendsGroupModel * groupModel = _datas[indexPath.section];
    NSArray * friends = groupModel.Friend;
    MyFriendsModel * model = friends[indexPath.row];
    
    
    

    ConversationModel * conversationModel = [ConversationModel new];
    conversationModel.Id = model.userID;
    conversationModel.name = model.userName;
    conversationModel.imgUrl = model.HeadName;
    conversationModel.GroupMsg = NO;
    
    ChatViewController * chat=  [ChatViewController new];
    chat.conversationModel = conversationModel;
    [self.navigationController pushViewController:chat animated:YES];
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
