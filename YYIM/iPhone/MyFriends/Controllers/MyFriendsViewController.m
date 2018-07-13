//
//  MyFriendsViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "MyFriendTableViewCell.h"
#import "MyFriendListModel.h"
#import "ChatViewController.h"

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

    

    
    
}
-(void)initNavi{
    self.title = @"我的好友";
    
}
-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[MyFriendTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    
}
-(void)refreshUI{
    [_tableView reloadData];
}


-(void)refreshData{
    NSString * userName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
//    userName = @"15701344579";
    
    [ProgressTool show];
    [Request getUserInfoWithIdOrName:userName success:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];
        
        if (code == 200) {
            NSMutableArray * datam = [NSMutableArray array];
            for (NSDictionary * dic in data) {
                MyFriendListModel * model = [MyFriendListModel new];
                [model setValuesForKeysWithDictionary:dic];
                [datam addObject:model];
                [self->_datas addObject:model];
            }
            [self refreshUI];
            
        }
    } failure:^(NSError *error) {
        [ProgressTool hidden];
    }];
    
}

#pragma mark -- delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    MyFriendListModel * model = _datas[indexPath.section];
    
    cell.textLabel.text =[NSString stringWithFormat:@"手机号：%@ 邮箱：%@",model.Phone,model.Email];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[ChatViewController new] animated:YES];
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
