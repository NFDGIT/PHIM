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
#import "PersonManager.h"

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
    
//    [ProgressTool show];
//    [Request joinGroupWithIdOrName:CurrentUserId groupId:@"123" success:^(NSUInteger code, NSString *msg, id data) {
//        [ProgressTool hidden];
//        if (code == 200) {
//
//        }
//        [self.view makeToast:data duration:2 position:CSToastPositionCenter];
//    } failure:^(NSError *error) {
//        [ProgressTool hidden];
//        [self.view makeToast:@"失败" duration:2 position:CSToastPositionCenter];
//    }];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
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
            [[PersonManager share]refreshGroupChats];
    

    
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

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
 
    
    MyGroupChatModel * model = _datas[indexPath.section];
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
