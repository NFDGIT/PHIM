//
//  GroupChatSettingViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/25.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "GroupChatSettingViewController.h"
#import "UserInfoModel.h"
#import "PersonDetailViewController.h"

@interface GroupChatSettingViewController ()
@property (nonatomic,strong)NSArray * infoModels;
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation GroupChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (void)initData{
    
    
}
- (void)initNavi{
    self.title = @"小群";
    
}
- (void)initUI{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, ContentHeight)];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    CGFloat setY = 0;
    
    {
        UIScrollView * groupMember = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width, 100)];
        groupMember.backgroundColor = ColorWhite;
        [scrollView addSubview:groupMember];
        [self refreshGroupMember:groupMember];
        setY = groupMember.bottom + 20;
    }

    
    
    
    for (int i = 0; i < 7; i ++) {
        UIButton * item = [[UIButton alloc]initWithFrame:CGRectMake(0, setY+0.5, _scrollView.width, 50)];
        if (i == 0  || i == 3 || i == 5) {
            item.top = setY + 20;
        }
        if (i == 6) {
            item.top = setY + 100;
        }
        
        item.backgroundColor = ColorWhite;
        item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_scrollView addSubview:item];
        
        
        if (i == 0) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"   管理群" forState:UIControlStateNormal];
            
        }
        if (i == 1) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"   我的群名片" forState:UIControlStateNormal];
        }
        if (i == 2) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"   查找聊天内容" forState:UIControlStateNormal];
        }
        if (i == 3) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"   置顶群聊天" forState:UIControlStateNormal];
            
            UISwitch * switch1 = [UISwitch new];
            //            switch1.tintColor = ColorTheme;
            switch1.onTintColor = ColorTheme;
            switch1.right = item.width - 20;
            switch1.centerY = item.height / 2;
            [item addSubview:switch1];
            
        }
        if (i == 4) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"   消息免打扰" forState:UIControlStateNormal];
            
            UISwitch * switch1 = [UISwitch new];
            //            switch1.tintColor = ColorTheme;
            switch1.onTintColor = ColorTheme;
            switch1.right = item.width - 20;
            switch1.centerY = item.height / 2;
            [item addSubview:switch1];
        }
        if (i == 5) {
            [item setTitleColor:ColorBlack forState:UIControlStateNormal];
            [item setTitle:@"   清空聊天记录" forState:UIControlStateNormal];
            [item addTarget:self action:@selector(clearChatHistory) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 6) {
            item.backgroundColor = ColorRed;
            [item setTitleColor:ColorWhite forState:UIControlStateNormal];
            item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [item setTitle:@"退出群聊" forState:UIControlStateNormal];
            item.width = ScreenWidth * 0.9;
            item.centerX = _scrollView.width/2;
            item.layer.cornerRadius = 5;
        }
        
        
        setY = item.bottom;
    }
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, setY);

    
    
}
-(void)refreshGroupMember:(UIScrollView *)groupMember{
    [groupMember.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    UserInfoModel * infoModel = [UserInfoModel new];
    infoModel.userID = @"13383824275";
    infoModel.HeadName = @"63";
    infoModel.RealName = @"彭辉";
    
    NSArray * members = @[infoModel,infoModel,infoModel,infoModel,infoModel,infoModel,infoModel];
    _infoModels = members;
    
    
    CGFloat setX = 10;
    CGFloat space = 20;
    
    CGFloat btnH = 80;
    CGFloat btnW = 60;
    

    for (int i = 0; i <= _infoModels.count; i ++) {
       
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(setX, space, btnW, btnH)];
        [groupMember addSubview:btn];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(clickUser:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == _infoModels.count) {
            [btn setImage:[UIImage imageNamed:@"groupchatset_add"] forState:UIControlStateNormal];
            [btn setTitle:@"邀请" forState:UIControlStateNormal];
        }else{
            UserInfoModel * currentInfoModel = _infoModels[i];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",currentInfoModel.HeadName]] forState:UIControlStateNormal];
            [btn setTitle:currentInfoModel.RealName forState:UIControlStateNormal];
        }
        
        

        
        
        
        [btn setTitleColor:ColorBlack forState:UIControlStateNormal];
        btn.titleLabel.height = 20;
        
        btn.imageView.width = btnW;
        btn.imageView.height = btnW;
        btn.titleLabel.backgroundColor  = ColorRed;
        
        
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.width, 0, btn.imageView.width)];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];


        btn.imageView.layer.cornerRadius = btn.width/ 2;
        
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,20, 0)];//图片距离右边框距离减少图片的宽度，其它不边

        
        
        setX = btn.right + space;
        
    }
    
    
    groupMember.contentSize = CGSizeMake(setX, groupMember.height);
    groupMember.height = space + btnH + space;
}

#pragma mark -- 点击事件
-(void)clickUser:(UIButton *)sender{
    if (sender.tag - 100 > _infoModels.count -1) {
        return;
    }
    
    UserInfoModel * model = _infoModels[sender.tag - 100];
    [self jumpToDetailWithInfoModel:model];

}
-(void)jumpToDetailWithInfoModel:(UserInfoModel *)infoModel{
    
    PersonDetailViewController * detail = [PersonDetailViewController new];
    detail.Id = infoModel.userID;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)clearChatHistory{
    [PHAlert  showConfirmWithTitle:@"提示" message:@"确定要清除聊天记录吗？" block:^{
        
    }];
    //    [MessageManager share]
    
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
