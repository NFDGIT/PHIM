//
//  CreateGroupViewController.m
//  YYIM
//
//  Created by Jobs on 2018/8/22.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()
@property (nonatomic,strong)UITextField * groupIdTF;
@property (nonatomic,strong)UITextField * groupNameTF;
@property (nonatomic,strong)UITextField * groupDescTF;


@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initNavi];
    [self initUI];
    // Do any additional setup after loading the view.
}

-(void)initData{
    

}
-(void)initNavi{
    self.title = @"创建群聊";
    
}
-(void)initUI{
    
    
    UIView * oldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    oldView.backgroundColor = ColorWhite;
    
    [self.view addSubview:oldView];
    [oldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(Scale(120));
    }];
    
    
    
    UILabel * oldPass= [[UILabel alloc]init];
    oldPass.text = @"    群ID";
    oldPass.textColor = ColorBlack;
    oldPass.backgroundColor = ColorBack;
    [oldView addSubview:oldPass];
    [oldPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(oldView.mas_width);
        make.height.mas_equalTo(Scale(60));
    }];
    
    
    
    UITextField * oldTF =[[UITextField alloc]init];
    oldTF.keyboardType= UIKeyboardTypeAlphabet;
    [oldView addSubview:oldTF];
    oldTF.placeholder = @"请输入群ID";
    oldTF.textColor = ColorBlack;
    [oldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.top.mas_equalTo(oldPass.mas_bottom).offset(Scale(10));
        make.width.mas_equalTo(oldView.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(40));
        
    }];
    _groupIdTF= oldTF;
    
    
    UIView * newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    newView.backgroundColor = ColorWhite;
    [self.view addSubview:newView];
    [newView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oldView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(Scale(120));
    }];
    
    
    UILabel * newPass= [[UILabel alloc]init];
    newPass.text = @"    群名称";
    newPass.textColor = ColorBlack;
    newPass.backgroundColor = ColorBack;
    [newView addSubview:newPass];
    [newPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(newView.mas_width);
        make.height.mas_equalTo(60);
    }];
    
    
    
    UITextField * newTF =[[UITextField alloc]init];
    newTF.keyboardType= UIKeyboardTypeDefault;
    [newView addSubview:newTF];
    newTF.placeholder = @"请输入群名称";
    newTF.textColor = ColorBlack;
    [newTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.top.mas_equalTo(newPass.mas_bottom).offset(Scale(10));
        make.width.mas_equalTo(newView.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(40));
        
    }];
    _groupNameTF = newTF;
    
    
    
    
    UIView * newView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    newView1.backgroundColor = ColorWhite;
    [self.view addSubview:newView1];
    [newView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(newView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(Scale(120));
    }];
    
    
    UILabel * newPass1= [[UILabel alloc]init];
    newPass1.text = @"    群说明";
    newPass1.textColor = ColorBlack;
    newPass1.backgroundColor = ColorBack;
    [newView1 addSubview:newPass1];
    [newPass1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(newView.mas_width);
        make.height.mas_equalTo(60);
    }];
    
    
    
    UITextField * newTF1 =[[UITextField alloc]init];
    newTF1.keyboardType= UIKeyboardTypeDefault;
    [newView1 addSubview:newTF1];
    newTF1.placeholder = @"请输入群说明";
    newTF1.textColor = ColorBlack;
    [newTF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.top.mas_equalTo(newPass1.mas_bottom).offset(Scale(10));
        make.width.mas_equalTo(newView1.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(40));
        
    }];
    _groupDescTF = newTF1;
    
    
    
    UIButton * btnSure = [[UIButton alloc]init];
    btnSure.backgroundColor = ColorRed;
    btnSure.layer.cornerRadius = 5;
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(newView1.mas_bottom).offset(Scale(50));
        make.centerX.mas_equalTo(newView1.mas_centerX);
        make.width.mas_equalTo(self.view.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(50));
    }];
    
    
    [btnSure addTarget:self action:@selector(setpassword) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -- 点击事件
-(void)setpassword{
    if ([_groupIdTF.text isEmptyString]) {
        [self.view makeToast:@"请输入群ID" duration:2 position:CSToastPositionCenter];
        return;
    }
    if ([_groupNameTF.text isEmptyString]) {
        [self.view makeToast:@"请输入群名称" duration:2 position:CSToastPositionCenter];
        return;
    }
    if ([_groupDescTF.text isEmptyString]) {
        [self.view makeToast:@"请输入群说明" duration:2 position:CSToastPositionCenter];
        return;
    }

    [ProgressTool show];
    [Request createGroupWithIdOrName:CurrentUserId groupId:_groupIdTF.text groupName:_groupNameTF.text groupNote:_groupDescTF.text success:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];
        if (code == 200) {
            [self.view makeToast:@"创建成功" duration:2 position:CSToastPositionCenter];
        }else{
            [self.view makeToast:data duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError *error) {
        [ProgressTool hidden];
        [self.view makeToast:@"创建失败" duration:2 position:CSToastPositionCenter];
    }];
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
