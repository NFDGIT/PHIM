//
//  MyGroupChatViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyGroupChatViewController.h"
#import "MyGroupChatTableViewCell.h"
#import "ChatViewController.h"

@interface MyGroupChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation MyGroupChatViewController

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

}
-(void)initNavi{
    self.title = @"我的群聊";
    
}
-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MyGroupChatTableViewCell class] forCellReuseIdentifier:@"cell"];
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
    
//    NSDictionary * dataDic = @{
//                               @"FriendDicationary":@[@{@"Dicationary":@"我的好友",@"Friend":@[@{@"userID":@"15904076020",@"userName":@"孙文",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"15"},@{@"userID":@"18516568515",@"userName":@"张志丹",@"UnderWrite":@"测试主管",@"HeadName":@"91"}]},
//                                                      @{@"Dicationary":@"朋友",@"Friend":@[@{@"userID":@"15904076020",@"userName":@"孙文",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"15"},@{@"userID":@"18516568515",@"userName":@"张志丹",@"UnderWrite":@"测试主管",@"HeadName":@"91"}]}],
//                               @"Groups": @[@{@"groupID":@"123",@"groupName":@"HELLO WORLD",@"groupDep":@"欢迎进入我的群！Q ！",@"memberList":@[@{@"userID":@"13522220187",@"userName":@"黄华东",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"66"},@{@"userID":@"15904076020",@"userName":@"孙文",@"UnderWrite":@"阿发斯蒂芬",@"HeadName":@"15"},@{@"userID":@"18511961198",@"userName":@"江飞洋",@"UnderWrite":@"产品经理",@"HeadName":@"10"},@{@"userID":@"18516568515",@"userName":@"张志丹",@"UnderWrite":@"测试主管",@"HeadName":@"91"}]}],
//                               @"userID":@"13522220187",
//                               @"userName":@"黄华东",
//                               @"UnderWrite":@"阿发斯蒂芬",
//                               @"HeadName":@"66"
//                               };
//
//    NSArray * data = dataDic[@"Groups"];
//
//    NSMutableArray * arr = [NSMutableArray array];
//    for (NSDictionary * dic in data) {
//        MyGroupChatModel * model = [MyGroupChatModel new];
//        [model setValuesForKeysWithDictionary:dic];
//        [arr addObject:model];
//    }
//    [_datas removeAllObjects];
//    [_datas addObjectsFromArray:arr];
//
//
//
//    [self refreshUI];
    
    
        NSString * userName =  CurrentUserId;
    
        [ProgressTool show];
        [Request getUserInfoWithIdOrName:userName success:^(NSUInteger code, NSString *msg, id data) {
            [ProgressTool hidden];
    
            if (code == 200) {
//                NSArray * data = dataDic[@"Groups"];
                NSString * dataString =[NSString stringWithFormat:@"%@",data[@"Groups"]];
                NSArray * datas =   [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                
                
                NSMutableArray * arr = [NSMutableArray array];
                for (NSDictionary * dic in datas) {
                    MyGroupChatModel * model = [MyGroupChatModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [arr addObject:model];
                }
                [self->_datas removeAllObjects];
                [self->_datas addObjectsFromArray:arr];
    
                
                
                    [self refreshUI];
            }
        } failure:^(NSError *error) {
            [ProgressTool hidden];
            [self.view makeToast:@"网络请求失败" duration:2 position:CSToastPositionCenter];
        }];
    
}

#pragma mark -- delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightWithIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGroupChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
 
    
    MyGroupChatModel * model = _datas[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGroupChatModel * groupModel = _datas[indexPath.section];
    ConversationModel * conversationModel = [ConversationModel new];
    conversationModel.Id = groupModel.groupID;
    conversationModel.name = groupModel.groupName;
    conversationModel.imgUrl = @"1";
    conversationModel.GroupMsg = YES;
    
    
    ChatViewController * chat=  [ChatViewController new];
    chat.conversationModel = conversationModel;
    [self.navigationController pushViewController:chat animated:YES];
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
