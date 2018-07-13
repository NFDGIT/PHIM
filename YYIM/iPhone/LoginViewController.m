//
//  LoginViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField * userNameTF;
@property (nonatomic,strong)UITextField * passwordTF;
@property (nonatomic,strong)UIButton    * loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    
    _userNameTF = [[UITextField alloc]init];
    _userNameTF.placeholder = @"请输入用户名";
    _userNameTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_userNameTF];
    _userNameTF.delegate = self;
    _userNameTF.text = @"15701344579";
    
    _passwordTF = [[UITextField alloc]init];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate = self;
    _passwordTF.text = @"123456";
    
    _loginBtn = [[UIButton alloc]init];
    _loginBtn.backgroundColor = [UIColor greenColor];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _passwordTF.frame = CGRectMake(100, 0, self.view.width - 200, 50);
    _passwordTF.center = CGPointMake(self.view.width/2, self.view.height/2);
    
    _userNameTF.frame =CGRectMake(100, 0, self.view.width, 50);
    _userNameTF.bottom = _passwordTF.top - 30;
    
    _loginBtn.frame =CGRectMake(0, _passwordTF.bottom + 50, 150, 40);
    _loginBtn.centerX = _passwordTF.centerX;
}

#pragma mark -- login
-(void)login{
    if (_userNameTF.text.length <= 0) {
        NSLog(@"%@",@"请输入用户名");
        return;
    }
    if (_passwordTF.text.length <= 0) {
        NSLog(@"%@",@"请输入密码");
        return;
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:_userNameTF.text forKey:@"UserName"];
    [((AppDelegate *)([UIApplication sharedApplication].delegate))  switchRootVC];
    return;
    
    [Request loginWithUserName:_userNameTF.text passWord:_passwordTF.text success:^(NSUInteger code, NSString *msg, id data) {
        if (code == 200) {
            
            [Request getUserInfoWithIdOrName:_userNameTF.text success:^(NSUInteger code, NSString *msg, id data) {
                if (code == 200) {
                    
                }
            } failure:^(NSError *error) {
                
            }];
            
            [[NSUserDefaults standardUserDefaults] setValue:_userNameTF.text forKey:@"UserName"];
            [((AppDelegate *)([UIApplication sharedApplication].delegate))  switchRootVC];
     }
    } failure:^(NSError *error) {
        
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
