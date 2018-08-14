//
//  UpdatePasswordViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/27.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "UpdatePasswordViewController.h"



@interface UpdatePasswordViewController ()
@property (nonatomic,strong)UITextField * oldTextF;
@property (nonatomic,strong)UITextField * nTextF;
@end

@implementation UpdatePasswordViewController

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
    
    self.title = @"修改密码";
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
    oldPass.text = @"    旧密码";
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
    [oldView addSubview:oldTF];
    oldTF.placeholder = @"请输入旧密码";
    oldTF.textColor = ColorBlack;
    [oldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.top.mas_equalTo(oldPass.mas_bottom).offset(Scale(10));
        make.width.mas_equalTo(oldView.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(40));
        
    }];
    _oldTextF  = oldTF;
    
    
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
    newPass.text = @"    新密码";
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
    [newView addSubview:newTF];
    newTF.placeholder = @"请输入新密码";
    newTF.textColor = ColorBlack;
    [newTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Scale(20));
        make.top.mas_equalTo(newPass.mas_bottom).offset(Scale(10));
        make.width.mas_equalTo(newView.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(40));
        
    }];
    _nTextF = newTF;
    
    
    UIButton * btnSure = [[UIButton alloc]init];
    btnSure.backgroundColor = ColorRed;
    btnSure.layer.cornerRadius = 5;
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(newView.mas_bottom).offset(Scale(50));
        make.centerX.mas_equalTo(newView.mas_centerX);
        make.width.mas_equalTo(self.view.mas_width).offset(-Scale(40));
        make.height.mas_equalTo(Scale(50));
    }];
    
    
    [btnSure addTarget:self action:@selector(setpassword) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- 点击事件
-(void)setpassword{
    if ([_oldTextF.text isEmptyString] || [_nTextF.text isEmptyString]) {
        [self.view makeToast:@"请输入密码" duration:2 position:CSToastPositionCenter];
        return;
    }
    
//    if (![_oldTextF.text isEqualToString:_nTextF.text]) {
//        [self.view makeToast:@"两次密码不一致" duration:2 position:CSToastPositionCenter];
//        return;
//    }
    [ProgressTool show];
    [Request updatePasswordWithIdOrName:CurrentUserId oldPassword:_oldTextF.text newPassword:_nTextF.text success:^(NSUInteger code, NSString *msg, id data) {
        [ProgressTool hidden];
        if (code == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[UIApplication sharedApplication].keyWindow makeToast:data duration:2 position:CSToastPositionCenter];
    } failure:^(NSError *error) {
        [ProgressTool hidden];
        [self.view makeToast:@"修改失败" duration:2 position:CSToastPositionCenter];
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
