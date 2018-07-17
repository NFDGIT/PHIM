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
#import "DBTool.h"


@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)ChatInputView * inputView;

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
    
//    MsgModel * model = [MsgModel new];
//    model.sendId = CurrentUserId;
//    model.receivedId = _userId;
//    model.target = self.userId;
//    model.content = @"fsafdadflasf";
//    [[DBTool share] addModel:model withTarget:self.userId response:^(BOOL success) {
//
//    }];
//    [[DBTool share] getMessagesWithTarget:self.userId success:^(NSArray *result) {
//
//    }];
    
    
}

-(void)initNavi{
    self.title = self.userId;
    
}
-(void)initUI{
    
    
    
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.width, ContentHeight)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor  =[UIColor lightGrayColor];
    _scrollView = scrollView;
    
    ChatInputView * inputView = [[ChatInputView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, 50)];
    [scrollView addSubview:inputView];
    inputView.inputBlock = ^(NSString *value) {
        [self sendAction:value];
    };
    inputView.changeHeightBlock = ^{
        [self layout];
    };
    inputView.inputAddDataBlock = ^(ChatAddType type, id data) {
        if (type == ChatAddTypeImage) {
            [self addImage:data];
        };
    };
    _inputView = inputView;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height - inputView.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[ChatCell class] forCellReuseIdentifier:@"cell"];
    [scrollView addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height);

    
    [self layout];
}



-(void)refreshUI{
    [_tableView reloadData];
    
             [self showLastMsg];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
 
}
-(void)refreshData{
    [[MessageManager share]getMessagesWithTargetId:self.userId success:^(NSArray * result) {
        self->_datas = [NSMutableArray arrayWithArray:result];
        [self refreshUI];
    }];
     [self refreshUI];
//    _datas =[NSMutableArray arrayWithArray:[[MessageManager share]getMessagesWithTargetId:self.userId]];
    
   
}
-(void)layout{
    _inputView.bottom = _scrollView.height;
    
    _tableView.height = _inputView.top;
}
#pragma mark -- 点击事件
-(void)sendAction:(NSString *)msg{
    [[SocketTool share] sendMsg:msg receiveId:[NSString stringWithFormat:@"%@",_userId]  msgInfoClass:12];
    
    
    MsgModel * model = [MsgModel new];
    model.target =_userId;
    model.sendId = CurrentUserId;
    model.receivedId = _userId;
    model.content = msg;
    model.msgType = MsgTypeText;
    [[MessageManager share] addMsg:model toTarget:self.userId];

    [self refreshData];

}
-(void)addImage:(UIImage *)image{
//    [[SocketTool share] sendMsg:msg receiveId:[NSString stringWithFormat:@"%@",_userId]  msgInfoClass:12];
    
    
    MsgModel * model = [MsgModel new];
    model.target = _userId;
    model.sendId = CurrentUserId;
    model.receivedId = _userId;
    model.msgType = MsgTypeImage;
    model.content = @"";
    model.imageUrl = @"http://img1.imgtn.bdimg.com/it/?u=3920398476,1501488149&fm=27&gp=0.jpg&width=200&height=300";
    [[MessageManager share] addMsg:model toTarget:self.userId];
    
    [self refreshData];
    
}

-(void)receiveNewMsg:(NSNotification *)noti{
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
-(void)showLastMsg{
//    if (_datas.count <= 0) {
//        return;
//    }
//
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:_datas.count-1];
//    UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
//    if (!cell) {
//        return;
//    }
    
    
//    [UIView animateWithDuration:1 animations:^{
////        self->_tableView.contentOffset = CGPointMake(0, cell.bottom - self->_tableView.height);
//        self->_tableView.contentOffset = CGPointMake(0, self->_tableView.contentSize.height - _tableView.height);
//    }];
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
