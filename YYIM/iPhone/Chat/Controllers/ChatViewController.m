//
//  ChatViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "ChatInputView.h"
#import "SocketTool.h"
#import "MessageManager.h"


@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,strong)NSMutableArray * datas;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    [self refreshData];
    
//    [self refreshData];
    // Do any additional setup after loading the view.
}

-(void)initData{
    _datas = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg:) name:NotiForReceiveMsgInfoClass12 object:nil];
}

-(void)initNavi{
    self.title = self.userId;
    
}
-(void)initUI{
    
    
    
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.width, ContentHeight)];
    
    [self.view addSubview:scrollView];
    scrollView.backgroundColor  =[UIColor lightGrayColor];
    
    ChatInputView * inputView = [[ChatInputView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, 50)];
    inputView.top = scrollView.height- inputView.topView.bottom;
    [scrollView addSubview:inputView];
    inputView.inputBlock = ^(NSString *value) {
        [self sendAction:value];
    };
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height - inputView.topView.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[ChatCell class] forCellReuseIdentifier:@"cell"];
    [scrollView addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height);

}
-(void)refreshUI{
    [_tableView reloadData];
}
-(void)refreshData{
    _datas =[NSMutableArray arrayWithArray:[[MessageManager share]getMessagesWithTargetId:self.userId]];
    
    [self refreshUI];
}
#pragma mark -- 点击事件
-(void)sendAction:(NSString *)msg{
    [[SocketTool share] sendMsg:msg receiveId:[NSString stringWithFormat:@"%@",_userId]  msgInfoClass:12];
    
    
    MsgModel * model = [MsgModel new];
    model.sendId = CurrentUserId;
    model.receivedId = _userId;
    model.content = msg;
    [[MessageManager share] addMsg:model toTarget:self.userId];

    [self refreshData];

}
-(void)receiveNewMsg:(NSNotification *)noti{
//    NSDictionary * MsgContent =[NSDictionary dictionaryWithDictionary:noti.object];
//    NSString *  MsgInfoClass = [NSString stringWithFormat:@"%@",MsgContent[@"MsgInfoClass"]];
//    NSString *  ReceiveId = [NSString stringWithFormat:@"%@",MsgContent[@"ReceiveId"]];
//    NSString *  SendID = [NSString stringWithFormat:@"%@",MsgContent[@"SendID"]];
//
//    if ([MsgInfoClass isEqualToString:@"12"] && [ReceiveId isEqualToString:CurrentUserId]) {
//
//        if (MsgContent && [MsgContent.allKeys containsObject:@"MsgContent"]) {
//
//            NSString * msg = [NSString stringWithFormat:@"%@",MsgContent[@"MsgContent"][@"MsgContent"]];
//
//            MsgModel * model = [MsgModel new];
//            model.sendId = SendID;
//            model.receivedId = ReceiveId;
//            model.content = msg;
//            [[MessageManager share] addMsg:model toTarget:self.userId];
//            [self refreshData];
//
//        }
//
//
//    }
    [self refreshData];
    
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
    ChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    
    MsgModel * model = _datas[indexPath.section];
    cell.model = model;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
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
