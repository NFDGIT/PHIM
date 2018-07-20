//
//  LoginViewController.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"


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
    _userNameTF.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self.view addSubview:_userNameTF];
    _userNameTF.delegate = self;
    _userNameTF.textAlignment = NSTextAlignmentCenter;
    _userNameTF.text = @"15701344579";
    
    _passwordTF = [[UITextField alloc]init];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.font = [UIFont systemFontOfSize:14];
    _passwordTF.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate = self;
    _passwordTF.textAlignment = NSTextAlignmentCenter;
    _passwordTF.text = @"123456";
    
    _loginBtn = [[UIButton alloc]init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:ColorBlack forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = FontBig;
    [self.view addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _passwordTF.frame = CGRectMake(0, 0, self.view.width * 0.7, 50);
    _passwordTF.center = CGPointMake(self.view.width/2, self.view.height/2);
    
    _userNameTF.frame =CGRectMake(0, 0, self.view.width * 0.7, 50);
    _userNameTF.bottom = _passwordTF.top - 30;
    
    _loginBtn.frame =CGRectMake(0, _passwordTF.bottom + 50, 150, 40);
    _userNameTF.centerX =  _loginBtn.centerX = _passwordTF.centerX ;
}

#pragma mark -- login
-(void)login{
    if (_userNameTF.text.length <= 0) {
        [self.view makeToast:@"请输入用户名" duration:2 position:CSToastPositionCenter];
        return;
    }
    if (_passwordTF.text.length <= 0) {
        [self.view makeToast:@"请输入密码" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    
//    setCurrentUserId(_userNameTF.text);
//    setCurrentUserIcon(@"1");
//    [((AppDelegate *)([UIApplication sharedApplication].delegate))  switchRootVC];
//    
//
//    return;
    
    
    [ProgressTool show];
    [Request loginWithUserName:_userNameTF.text passWord:_passwordTF.text success:^(NSUInteger code, NSString *msg, id data) {
           [ProgressTool hidden];
        
        if (code == 200) {
//            setCurrentUserId(self->_userNameTF.text);
//            [[NSUserDefaults standardUserDefaults] setValue:self->_userNameTF.text forKey:@"UserName"];

//          Request get
            
            [Request getUserInfo1WithIdOrName:self->_userNameTF.text success:^(NSUInteger code, NSString *msg, id data) {
                if (code == 200) {
                    UserInfoModel * model = [UserInfoModel new];
                    [model setValuesForKeysWithDictionary:data];
                    
                    
                    
                    
                    NSString *  HeadName = model.HeadName;
                    NSString *  UnderWrite = model.UnderWrite;
                    NSString *  userID = model.userID;
                    NSString *  userName = model.RealName;
                    NSString *  UserStatus = model.UserStatus;
                    
                    setCurrentUserId(userID);
                    setCurrentUserIcon(HeadName);
                    setCurrentUserName(userName);
                    setCurrentUserUnderWrite(UnderWrite);
                    setCurrentUserStatus([UserStatus integerValue]);
                    [((AppDelegate *)([UIApplication sharedApplication].delegate))  switchRootVC];
                }else{
                    [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
                }
            } failure:^(NSError *error) {
                    [self.view makeToast:@"网络请求失败" duration:2 position:CSToastPositionCenter];
            }];
       
     }
    } failure:^(NSError *error) {
            [ProgressTool hidden];
        [self.view makeToast:@"网络请求失败" duration:2 position:CSToastPositionCenter];
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
