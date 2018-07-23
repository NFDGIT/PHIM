//
//  PersonDetailViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "ChatViewController.h"
#import "UserInfoModel.h"
#import "PersonManager.h"
#import "MessageManager.h"

@interface PersonDetailViewController ()
@property (nonatomic,strong)UserInfoModel * infoModel;

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel * labelName;
@property (nonatomic,strong)UILabel * labelDesc;
@property (nonatomic,strong)UILabel * labelPhone;
@property (nonatomic,strong)UILabel * labelEmail;
@property (nonatomic,strong)UILabel * labelReal;
@property (nonatomic,strong)UILabel * labelSex;

@property (nonatomic,strong)UIButton * btnChangeFriend;
@property (nonatomic,strong)UIButton * btnMessage;


@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    [self refreshData];
    // Do any additional setup after loading the view.
}
-(void)initData{
    _infoModel = [UserInfoModel new];
    
}
-(void)initNavi{
    self.title = @"用户详情";
    
}
-(void)initUI{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:scrollView];
    _scrollView  =  scrollView;
    
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [scrollView addSubview:headImg];
    _headImg = headImg;
    
    for (int i = 0; i < 6; i ++) {
        UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor  = ColorBlack;
        label.font = FontBig;
        [scrollView addSubview:label];
        
        
        switch (i) {
            case 0:
                _labelName = label;
                break;
            case 1:
                _labelDesc = label;
                break;
            case 2:
                _labelPhone = label;
                break;
            case 3:
                _labelEmail = label;
                break;
            case 4:
                _labelReal = label;
                break;
            case 5:
                _labelSex = label;
                break;
                
            default:
                break;
        }
        
        
    }
    
    

    
    
    
    UIButton * btnChangeFriend = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width/2, 50)];
    btnChangeFriend.backgroundColor = ColorWhite;
    [btnChangeFriend setTitleColor:ColorBlack forState:UIControlStateNormal];
    btnChangeFriend.titleLabel.font = FontBig;
    [btnChangeFriend setTitle:@"加好友" forState:UIControlStateNormal];
    [self.view addSubview:btnChangeFriend];
    [btnChangeFriend addTarget:self action:@selector(changeFriend) forControlEvents:UIControlEventTouchUpInside];
    _btnChangeFriend = btnChangeFriend;
    
    
    UIButton * btnMessage = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2, 0, self.view.width/2, 50)];
    btnMessage.backgroundColor = ColorRed;
    [btnMessage setTitleColor:ColorWhite forState:UIControlStateNormal];
    btnMessage.titleLabel.font = FontBig;
    [btnMessage setTitle:@"发消息" forState:UIControlStateNormal];
    [self.view addSubview:btnMessage];
    [btnMessage addTarget:self action:@selector(jumpToChatVC) forControlEvents:UIControlEventTouchUpInside];
    
    btnChangeFriend.bottom = btnMessage.bottom = self.view.height;
    
    _btnMessage = btnMessage;
    
    
}
-(void)layout{
    _scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    CGFloat setY = 50;
    
    
    _headImg.top = setY;
    _headImg.centerX = _scrollView.width / 2;
    setY = _headImg.bottom;

    
    
    _labelName.top = setY + 20;
    _labelName.width = _scrollView.width;
    _labelName.centerX = _scrollView.width / 2;
    setY = _labelName.bottom;
    
    
    
    _labelReal.top = setY + 20;
    _labelReal.width = _scrollView.width;
    _labelReal.centerX = _scrollView.width / 2;
    setY = _labelReal.bottom;
    
    
    _labelDesc.top = setY + 20;
    _labelDesc.width = _scrollView.width;
    _labelDesc.centerX = _scrollView.width / 2;
    setY = _labelDesc.bottom;
    
    
    _labelEmail.top = setY + 20;
    _labelEmail.width = _scrollView.width;
    _labelEmail.centerX = _scrollView.width / 2;
    setY = _labelEmail.bottom;
    
    
    _labelPhone.top = setY + 20;
    _labelPhone.width = _scrollView.width;
    _labelPhone.centerX = _scrollView.width / 2;
    setY = _labelPhone.bottom;
    
    
    _labelSex.top = setY + 20;
    _labelSex.width = _scrollView.width;
    _labelSex.centerX = _scrollView.width / 2;
    setY = _labelSex.bottom;
 
    
    setY = _labelSex.bottom + 20;
    
    
    _btnChangeFriend.left = 0;
    _btnMessage.right = self.view.width;
    _btnChangeFriend.bottom = _btnMessage.bottom = self.view.height;
    
    
    
    
//    _btnMessage.top = setY + 20;
//    _btnMessage.centerX = _scrollView.width / 2;
    

    
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self layout];
    
}
-(void)refreshData{
    
    UserInfoModel * model = [[PersonManager share]getModelWithId:_Id];
    _infoModel = model;
    [self refreshUI];
    
}
-(void)refreshUI{

    _headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",_infoModel.HeadName]];
    _labelName.text = [NSString stringWithFormat:@"昵称：%@",_infoModel.userName];
    _labelReal.text = [NSString stringWithFormat:@"真实姓名：%@",_infoModel.RealName];
    _labelSex.text = [NSString stringWithFormat:@"性别：%@",_infoModel.Sex];
    _labelEmail.text = [NSString stringWithFormat:@"邮箱：%@",_infoModel.Email];
    _labelPhone.text = [NSString stringWithFormat:@"手机号：%@",_infoModel.Phone];
    _labelDesc.text = [NSString stringWithFormat:@"签名：%@",_infoModel.UnderWrite];
    
    
    
}

#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -- 点击事件

-(void)changeFriend{
    [[SocketTool share] sendMsg:@"" receiveId:@"" msgInfoClass:InformationTypeGetFriendIDList isGroup:NO];
    
    
}
-(void)jumpToChatVC{
    if ([_Id isEmptyString]) {
        [self.view makeToast:@"Id 不存在" duration:2 position:CSToastPositionCenter];
        return;
    }

    [[MessageManager share] getConversationWithId:_Id response:^(ConversationModel *model) {
        if (model) {
   
        }else{
            ConversationModel * newconversationModel = [ConversationModel new];
            newconversationModel.Id = self->_infoModel.userID;
            model = newconversationModel;
        }
        
        ChatViewController * chat = [ChatViewController new];
        chat.conversationModel = model;
        [self.navigationController pushViewController:chat animated:YES];
        
        
    }];


    
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
