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
    
//    if (!_targetModel) {
//        _targetModel = [MessageTargetModel new];
//        _targetModel.Id = _userId;
//    };
//    [self refreshData];
    // Do any additional setup after loading the view.
}

-(void)initData{
    _datas = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg:) name:NotiForReceiveMsgInfoClass12 object:nil];

}


-(void)initNavi{
    self.title = _targetModel.Id;
    
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
    _tableView.estimatedRowHeight = 100;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height);

    
    [self layout];
}



-(void)refreshUI{
    [_tableView reloadData];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self scrollTableToFoot:YES];
        [self scrollToBottomisAnimated:YES];
    });
 
}
-(void)refreshData{
    
    NSString * targetId = _targetModel.Id;
    [[MessageManager share]getMessagesWithTargetId:targetId success:^(NSArray * result) {
        self->_datas = [NSMutableArray arrayWithArray:result];
        [self refreshUI];
    }];
//     [self refreshUI];
   
}
-(void)layout{
    _inputView.bottom = _scrollView.height;
    
    _tableView.height = _inputView.top;
}
#pragma mark -- 点击事件
-(void)sendAction:(NSString *)msg{
    [[SocketTool share] sendMsg:msg receiveId:[NSString stringWithFormat:@"%@",_targetModel.Id]  msgInfoClass:12];
    
    MsgModel * model = [MsgModel new];

    model.target =_targetModel.Id;
    model.sendId = CurrentUserId;
//    model.targetHeadName = _targetModel.imgUrl;
    
    
    
    model.receivedId = _targetModel.Id;
    model.content = msg;
    model.msgType = MsgTypeText;
    model.headIcon = CurrentUserIcon;
    [[MessageManager share] addMsg:model toTarget:_targetModel];

    [self refreshData];

}
-(void)addImage:(UIImage *)image{
//    [[SocketTool share] sendMsg:msg receiveId:[NSString stringWithFormat:@"%@",_userId]  msgInfoClass:12];
    
    
    MsgModel * model = [MsgModel new];
//    model.targetHeadName = _targetModel.imgUrl;
    model.target = _targetModel.Id;
    model.sendId = CurrentUserId;
    model.receivedId = _targetModel.Id;
    model.msgType = MsgTypeImage;
    model.headIcon = CurrentUserIcon;
    model.content = @"";
    model.imageUrl = @"http://img1.imgtn.bdimg.com/it/?u=3920398476,1501488149&fm=27&gp=0.jpg&width=200&height=300";
    [[MessageManager share] addMsg:model toTarget:_targetModel];
    
    [self refreshData];
    
}

-(void)receiveNewMsg:(NSNotification *)noti{
    [self refreshData];
}


#pragma mark -- delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
    return [tableView cellHeightWithIndexPath:indexPath];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    
    MsgModel * model = _datas[indexPath.section];
    cell.model = model;
    return cell;
}
#pragma mark  - 滑到最底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}
- (void)scrollToBottomisAnimated:(BOOL)isAnimated {
    if (self.datas.count == 0) {
        return;
    }
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:0 inSection:self.datas.count-1];
        [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:isAnimated];
    });
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
