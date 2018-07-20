//
//  MineViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MineViewController.h"


#import "MyFriendsViewController.h"
#import "MyGroupChatViewController.h"
#import "UserChangeStatus.h"


#import "AppDelegate.h"
@interface MineViewController ()
@property (nonatomic,strong)UIImageView * headView;
@property (nonatomic,strong)UILabel * labelName;
@property (nonatomic,strong)UILabel * labelDesc;
@property (nonatomic,strong)UIButton * btnStatus;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self initUI];
    [self refreshUI];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
}

-(void)initNavi{
    self.title = @"我的";
}
-(void)initUI{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    [self.view addSubview:scrollView];
    
    
    CGFloat setY = 0;
    
    UIView * userBackView = [[UIView alloc]initWithFrame:CGRectMake(0, setY + 20, scrollView.width, 100)];
    userBackView.backgroundColor  =[UIColor whiteColor];
    setY = userBackView.bottom + 20;
    [scrollView addSubview:userBackView];
    
    {
        UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",CurrentUserIcon]];
        [userBackView addSubview:headImg];
        _headView = headImg;
        
        
        UILabel * labelName =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        labelName.textColor  = ColorBlack;
        labelName.font = FontBig;
        [userBackView addSubview:labelName];
        labelName.text = [NSString stringWithFormat:@"%@",CurrentUserId];
        _labelName = labelName;
        
        
        UILabel * labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        labelDesc.textColor  = ColorBlack;
        labelDesc.font = FontBig;
        [userBackView addSubview:labelDesc];
        labelDesc.text = [NSString stringWithFormat:@"%@",CurrentUserId];
        _labelDesc = labelDesc;
        
        
        UIButton * btnStatus = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        [btnStatus setTitleColor:ColorRed forState:UIControlStateNormal];
        btnStatus.titleLabel.font = FontBig;
        [userBackView addSubview:btnStatus];
        [btnStatus addTarget:self action:@selector(changeStatus) forControlEvents:UIControlEventTouchUpInside];
        _btnStatus = btnStatus;
        
        
        _headView.centerY = userBackView.height/2;
        _headView.left = 10;
     
        
        _labelName.left = headImg.right  +10;
        _labelName.bottom = headImg.centerY - 5;
        
        _labelDesc.left = headImg.right  + 10;
        _labelDesc.top = headImg.centerY + 5;
        
        
        _btnStatus.right = userBackView.width - 20;
        _btnStatus.top = 20;

    }

    
    
    


    

    
    
    UIButton * logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, setY + 20, 100, 40)];
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:ColorRed];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:logoutBtn];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        setY  = logoutBtn.bottom;
    
    logoutBtn.width = scrollView.width * 0.5;
    logoutBtn.bottom = scrollView.height - 100;
    logoutBtn.centerX = scrollView.width /2;
    
    
    
}
-(void)refreshUI{
    _headView.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",CurrentUserIcon]];
    _labelName.text = CurrentUserName;
    _labelDesc.text = CurrentUserUnderWrite;
    
    NSArray * titles = @[@"离线",@"在线",@"隐身",@"离开",@"繁忙",@"勿扰"];
    [_btnStatus setTitle:[NSString stringWithFormat:@"%@",titles[CurrentUserStatus]] forState:UIControlStateNormal];
    [[SocketTool share]sendMsg:@"" receiveId:@"" msgInfoClass:InformationTypeNewUserLogin isGroup:NO];
}

#pragma mark -- 点击事件
-(void)changeStatus{
    UserChangeStatus * userchange = [UserChangeStatus new];
    __weak typeof(userchange) weakChange = userchange;
    __weak typeof(self)   weakSelf = self;
    
    [userchange appear];
    userchange.userStatus = CurrentUserStatus;
    
    userchange.changeStatusBlock = ^(UserStatus userStatus) {
        setCurrentUserStatus(userStatus);
        [weakChange disAppear];
        [weakSelf refreshUI];
    
        
    };
    
}
-(void)jumpToMyFriend{
    [self.navigationController pushViewController:[MyFriendsViewController new] animated:YES];
}
-(void)jumpToMyGroup{
    [self.navigationController pushViewController:[MyGroupChatViewController new] animated:YES];
}
-(void)logout{
    setCurrentUserId(@"");
    [((AppDelegate *)[UIApplication sharedApplication].delegate) switchRootVC];

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
