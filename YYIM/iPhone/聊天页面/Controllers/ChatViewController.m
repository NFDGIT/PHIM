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


#import "ChatSettingViewController.h"
#import "GroupChatSettingViewController.h"

#import "PersonManager.h"

#import "PersonDetailViewController.h"


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

    // Do any additional setup after loading the view.
}

-(void)initData{
    _datas = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    self.chatNewMessageBlock = ^(NSDictionary *data) {
        [weakSelf refreshData];
    };
}


-(void)initNavi{
    self.title = _conversationModel.Id;
    NSString * rightImgName = @"联系人_单人";
    
    
    if (_conversationModel.GroupMsg) {
         rightImgName = @"联系人_多人";
    }else{
        self.navigationItem.title = [[PersonManager share]getModelWithId:_conversationModel.Id].RealName;
        
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:rightImgName] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    
    
}
-(void)initUI{
    
    
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.width, ContentHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor  =[UIColor lightGrayColor];

    
    ChatInputView * inputView = [[ChatInputView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width, 50)];
    [_scrollView addSubview:inputView];
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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height - inputView.height) style:UITableViewStyleGrouped];
    [_tableView registerClass:[ChatCell class] forCellReuseIdentifier:@"cell"];
    [_scrollView addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 300;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height);

    
    [self layout];
}



-(void)refreshUI{

    
    
    [_tableView reloadData];
    

    [self scrollToBottom:YES];
 
}
-(void)refreshData{
    
    NSString * targetId = _conversationModel.Id;
    
    
    [[MessageManager share]getMessagesWithTargetId:targetId success:^(NSArray * result) {
        self->_datas = [NSMutableArray arrayWithArray:result];
        
        [self refreshUI];
    
    }];
}
-(void)layout{
    _inputView.bottom = _scrollView.height;
    
    _tableView.height = _inputView.top;
}
#pragma mark -- 点击事件
-(void)sendAction:(NSString *)msg{
    if (!serverOnLine) {
        [PHAlert showWithTitle:@"提示" message:@"别发啦！找不到服务器啦！！！" block:^{
        }];
        return;
    }
    
    
    [[SocketTool share] sendMsg:msg receiveId:[NSString stringWithFormat:@"%@",_conversationModel.Id]  msgInfoClass:InformationTypeChat isGroup:_conversationModel.GroupMsg];
    
    MsgModel * model = [MsgModel new];

    model.target =_conversationModel.Id;
    model.sendId = CurrentUserId;
    model.receivedId = _conversationModel.Id;
    model.content = msg;
    model.msgType = MsgTypeText;
    model.headIcon = CurrentUserIcon;
    model.MsgInfoClass = InformationTypeChat;
    model.GroupMsg = _conversationModel.GroupMsg;
    
    
    [[MessageManager share] addMsg:model toTarget:_conversationModel];

    [self refreshData];

}
-(void)addImage:(UIImage *)image{
    if (!serverOnLine) {
        [PHAlert showWithTitle:@"提示" message:@"别发啦！找不到服务器啦！！！" block:^{
        }];
        return;
    }
    
    
    
    [ProgressTool show];
    [Request uploadImage:image receiveId:_conversationModel.Id success:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];
        //上传成功
        NSString * success = [NSString stringWithFormat:@"%@",data[@"success"]];
        
        
        
        if ([success isEqualToString:@"true"]) {
            NSString * imgUrl = [NSString stringWithFormat:@"%@",data[@"imgUrl"]];
//            [[SocketTool share] sendMsg:@"" receiveId:[NSString stringWithFormat:@"%@",self->_conversationModel.Id] msgInfoClass:12 isGroup:self->_conversationModel.GroupMsg];
            
            MsgModel * model = [MsgModel new];
            model.target = self->_conversationModel.Id;
            model.sendId = CurrentUserId;
            model.receivedId = self->_conversationModel.Id;
            model.msgType = MsgTypeImage;
            model.headIcon = CurrentUserIcon;
            model.content = @"";
            model.imageUrl = imgUrl;
            model.MsgInfoClass = InformationTypeChat;
            model.GroupMsg = self->_conversationModel.GroupMsg;
            
            [[MessageManager share] addMsg:model toTarget:self->_conversationModel];
            
            [self refreshData];
            
        }
        
        
        [PHAlert showWithTitle:@"提示" message:[NSString stringWithFormat:@"上传成功:%@",data] block:^{
            
        }];
    } failure:^(NSError *error) {
        [ProgressTool hidden];
        //上传失败
        [PHAlert showWithTitle:@"提示" message:[NSString stringWithFormat:@"上传失败:%@",error] block:^{
            
        }];
    }];
    
//    return;
    

    

    
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
    
    cell.headClickBlock = ^(NSIndexPath *indexP) {
        MsgModel * tapModel = self->_datas[indexP.section];
        [self jumpToDetailWithId:tapModel.sendId];
    };
    return cell;
}
#pragma mark  - 滑到最底部
-(void)scrollToBottom:(BOOL)animated{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self scrollTableToFoot:animated];
    });
}



- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}
//- (void)scrollToBottomisAnimated:(BOOL)isAnimated {
//    if (self.datas.count == 0) {
//        return;
//    }
//    double delayInSeconds = 0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:0 inSection:self.datas.count-1];
//        [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:isAnimated];
//    });
//}


#pragma mark -- 点击事件
-(void)rightClick{
    if (_conversationModel.GroupMsg) {
        GroupChatSettingViewController * setting = [GroupChatSettingViewController new];
        setting.Id =  _conversationModel.Id;
        [self.navigationController pushViewController:setting animated:YES];
    }else{
        ChatSettingViewController * setting = [ChatSettingViewController new];
        setting.Id =  _conversationModel.Id;
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    

    
}
-(void)jumpToDetailWithId:(NSString *)Id{
    PersonDetailViewController * detail = [PersonDetailViewController new];
    detail.Id = Id;
    [self.navigationController pushViewController:detail animated:YES];
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
