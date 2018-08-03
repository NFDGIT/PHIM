//
//  ChatSettingViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/24.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatSettingViewController.h"
#import "UserInfoModel.h"
#import "PersonManager.h"
#import "MessageManager.h"
#import "PersonDetailViewController.h"

@interface ChatSettingViewController ()
@property (nonatomic,strong)UserInfoModel * infoModel;

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel * labelName;
@property (nonatomic,strong)UILabel * labelDesc;


@end

@implementation ChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    [self refreshData];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)initData{
    _infoModel = [UserInfoModel new];
    
}
-(void)initNavi{
    self.title = @"聊天设置";
    
}
- (void)initUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:_scrollView];
    
    CGFloat setY = 10;
    {
        UIButton * userBack = [[UIButton alloc]initWithFrame:CGRectMake(0, setY, _scrollView.width, 60)];
        
        userBack.backgroundColor  =ColorWhite;
        [_scrollView addSubview:userBack];
        [userBack addTarget:self action:@selector(jumpToDetail) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        headImg.layer.cornerRadius = headImg.height / 2;
        headImg.layer.masksToBounds = YES;
        [userBack addSubview:headImg];
        _headImg = headImg;
    
        
        
        UILabel * labelName = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right+10, 10, 200, 20)];
        labelName.font = FontBig;
        labelName.textColor = ColorBlack;
        [userBack addSubview:labelName];
        labelName.bottom = headImg.centerY -  5;
        _labelName = labelName;
    
        
        
        UILabel * labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right + 10, 0, 200, 20)];
        labelDesc.font = FontBig;
        labelDesc.textColor = ColorBlack;
        [userBack addSubview:labelDesc];
        labelDesc.top = headImg.centerY +5;
        _labelDesc = labelDesc;
        
        
        
        
        userBack.height = headImg.bottom + 10;
        
        setY = userBack.bottom;
    }


    
    for (int i = 0; i < 6; i ++) {
        UIButton * item = [[UIButton alloc]initWithFrame:CGRectMake(0, setY+0.5, _scrollView.width, 50)];
        if (i == 1  || i == 2 || i == 4) {
            item.top = setY + 20;
        }
        if (i == 5) {
            item.top = setY + 200;
        }
        
        item.backgroundColor = ColorWhite;
        item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_scrollView addSubview:item];
        
        
        if (i == 0) {
            [item setTitleColor:ColorTheme forState:UIControlStateNormal];
//            [item setImage:[UIImage imageNamed:@"groupchatset_add"] forState:UIControlStateNormal];
            [item setTitle:@"      发起群聊" forState:UIControlStateNormal];
            
        }
        if (i == 1) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"      查找聊天记录" forState:UIControlStateNormal];
        }
        if (i == 2) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"      置顶聊天" forState:UIControlStateNormal];
            
            UISwitch * switch1 = [UISwitch new];
//            switch1.tintColor = ColorTheme;
            switch1.onTintColor = ColorTheme;
            switch1.right = item.width - 20;
            switch1.centerY = item.height / 2;
            [item addSubview:switch1];

        }
        if (i == 3) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"      消息免打扰" forState:UIControlStateNormal];
            
            UISwitch * switch1 = [UISwitch new];
//            switch1.tintColor = ColorTheme;
            switch1.onTintColor = ColorTheme;
            switch1.right = item.width - 20;
            switch1.centerY = item.height / 2;
            [item addSubview:switch1];
        }
        if (i == 4) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"      清空聊天记录" forState:UIControlStateNormal];
            [item addTarget:self action:@selector(clearChatHistory) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 5) {
            item.backgroundColor = ColorRed;
            [item setTitleColor:ColorWhite forState:UIControlStateNormal];
            item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [item setTitle:@"删除好友" forState:UIControlStateNormal];
            item.width = ScreenWidth * 0.9;
            item.centerX = _scrollView.width/2;
            item.layer.cornerRadius = 5;
        }
        
        
        setY = item.bottom;
    }

    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, setY);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refreshData{
    
    
    
    UserInfoModel * infoModel = [[PersonManager share]getModelWithId:_conversationModel.Id];
    _infoModel = infoModel;
    [self refreshUI];
    
}
-(void)refreshUI{
    _headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",_infoModel.HeadName]];
    _labelName.text = [NSString stringWithFormat:@"%@",_infoModel.RealName];
    _labelDesc.text = [NSString stringWithFormat:@"%@",_infoModel.UnderWrite];
    
}
#pragma mark -- 点击事件
-(void)jumpToDetail{
    PersonDetailViewController * detail = [PersonDetailViewController new];
    detail.Id = _conversationModel.Id;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)clearChatHistory{
    [PHAlert  showConfirmWithTitle:@"提示" message:@"确定要清除聊天记录吗？" block:^(BOOL sure){
        if (sure) {
            [[MessageManager share]deleteMessagesWithConversationId:self->_conversationModel.Id response:^(BOOL success) {
                if (success) {
                    [self.view makeToast:@"删除成功" duration:2 position:CSToastPositionCenter];
                }
            }];
        };
        
        
    }];
//    [MessageManager share]
    
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
