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
@property (nonatomic,strong)UIImageView * headBackImg;
@property (nonatomic,strong)UILabel      * labelName;
@property (nonatomic,strong)UILabel      * labelDesc;



@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UIButton * btnName;
@property (nonatomic,strong)UIButton * btnDesc;
@property (nonatomic,strong)UIButton * btnPhone;
@property (nonatomic,strong)UIButton * btnEmail;
@property (nonatomic,strong)UIButton * btnReal;
@property (nonatomic,strong)UIButton * btnSex;

@property (nonatomic,strong)UIButton * btnChangeFriend;
@property (nonatomic,strong)UIButton * btnMessage;


@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self initNavi];
    [self refreshData];
    // Do any additional setup after loading the view.
}
-(void)initData{

    _infoModel = [UserInfoModel new];

}



-(void)initNavi{
    self.hiddeNavi = YES;
    
    UIButton * btnBack = [[UIButton alloc]initWithFrame:CGRectMake(15, StatusBarHeight + 10, 30, 30)];
    [btnBack setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    [btnBack addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(15));
        make.top.mas_equalTo(Scale(10) + StatusBarHeight);
        make.width.mas_equalTo(Scale(30));
        make.height.mas_equalTo(Scale(30));
    }];
    
    

    UILabel * labelTitle =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = FontBig;
    labelTitle.textColor = ColorWhite;
    labelTitle.text = @"基本资料";
    labelTitle.center = CGPointMake(self.view.width/2, btnBack.centerY);
    [self.view addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(StatusBarHeight + Scale(10));
        make.width.mas_equalTo(Scale(100));
        make.height.mas_equalTo(Scale(30));
    }];
    
    
    
    
    
}
-(void)initUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, ScreenHeight - NaviHeight)];
    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.width.mas_equalTo(self.view.mas_width);
//        make.height.mas_equalTo(self.view.mas_height);
//    }];
    

    UIImageView * headBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width , _scrollView.width * 0.8)];
    headBackImg.backgroundColor = ColorTheme;
    headBackImg.image = [UIImage imageNamed:@"personcenter_headback"];
    [_scrollView addSubview:headBackImg];
    _headBackImg = headBackImg;
//    [headBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.width.mas_equalTo(self->_scrollView.mas_width);
//        make.height.mas_equalTo(200);
//    }];
    
    
    {
        UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        headImg.layer.cornerRadius = headImg.height / 2;
        headImg.layer.masksToBounds = YES;
        [headBackImg addSubview:headImg];
        _headImg = headImg;
        
        
        

    }
    

    
    
    CGFloat setY = headBackImg.bottom + 30;
    for (int i = 0; i < 6; i ++) {
        
        
        UIButton * btn =[[UIButton alloc]initWithFrame:CGRectMake(0, setY+1, _scrollView.width, 50)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
        
        btn.backgroundColor = ColorWhite;
        [btn setTitleColor:ColorBlack forState:UIControlStateNormal];
        btn.titleLabel.font = FontBig;
        [_scrollView addSubview:btn];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        setY = btn.bottom;
        
        switch (i) {
            case 0:
                _btnName = btn;

                break;
            case 1:
                _btnDesc = btn;
                [_btnSex setImage:[UIImage imageNamed:@"detail_signature"] forState:UIControlStateNormal];
                break;
            case 2:
                _btnPhone = btn;
                [_btnPhone setImage:[UIImage imageNamed:@"detail_phone"] forState:UIControlStateNormal];
                break;
            case 3:
                _btnEmail = btn;
                [_btnEmail setImage:[UIImage imageNamed:@"detail_email"] forState:UIControlStateNormal];
                break;
            case 4:
                _btnReal = btn;
                
                break;
            case 5:
                _btnSex = btn;
                [_btnSex setImage:[UIImage imageNamed:@"detail_sex"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
        
    }
    
    

    
    
    
    UIButton * btnMessage = [[UIButton alloc]initWithFrame:CGRectMake(0, setY + 40, self.view.width* 0.9, 50)];
    btnMessage.backgroundColor = ColorRed;
    [btnMessage setTitleColor:ColorWhite forState:UIControlStateNormal];
    btnMessage.titleLabel.font = FontBig;
    [btnMessage setTitle:@"发消息" forState:UIControlStateNormal];
    [_scrollView addSubview:btnMessage];
    [btnMessage addTarget:self action:@selector(jumpToChatVC) forControlEvents:UIControlEventTouchUpInside];
    btnMessage.layer.cornerRadius = 5;
    btnMessage.centerX = self.view.width / 2;
    setY = btnMessage.bottom;
    
    
    _btnMessage = btnMessage;

    
}
-(void)layout{
    _scrollView.frame = CGRectMake(0, -StatusBarHeight, self.view.width, ScreenHeight + NaviHeight);
    CGFloat setY = 0;
    

    _headBackImg.top = setY;
    _headBackImg.centerX = _scrollView.width / 2;
    setY = _headBackImg.bottom;


    _headImg.center = CGPointMake(_headBackImg.width/2, _headBackImg.height/2);
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _btnMessage.bottom + 200);
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
    [_btnName setTitle:[NSString stringWithFormat:@"  %@",_infoModel.userName] forState:UIControlStateNormal];
    [_btnReal setTitle:[NSString stringWithFormat:@"  %@",_infoModel.RealName] forState:UIControlStateNormal];
    [_btnSex setTitle: [NSString stringWithFormat:@"  %@",_infoModel.Sex] forState:UIControlStateNormal];
    [_btnEmail setTitle: [NSString stringWithFormat:@"  %@",_infoModel.Email] forState:UIControlStateNormal];
    [_btnPhone setTitle: [NSString stringWithFormat:@"  %@",_infoModel.Phone] forState:UIControlStateNormal];
    [_btnDesc setTitle: [NSString stringWithFormat:@"  %@",_infoModel.UnderWrite] forState:UIControlStateNormal];
    
    
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
