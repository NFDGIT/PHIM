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
#import "NSString+MD5Encrypt.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIImageView * imgLogo;
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
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imgView.image = [UIImage imageNamed:@"login_background"];
    imgView.userInteractionEnabled = YES;
    self.view = imgView;
    
    _imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _imgLogo.image = [UIImage imageNamed:@"login_logo"];
    _imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imgLogo];

    
    _userNameTF = [[UITextField alloc]init];
    _userNameTF.height = 50;
    _userNameTF.placeholder = @"账号/手机号";
    _userNameTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_userNameTF];
    _userNameTF.delegate = self;
    _userNameTF.textColor = ColorWhite;
    _userNameTF.font = FontBig;
    _userNameTF.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:_userNameTF.placeholder attributes:@{NSForegroundColorAttributeName:ColorWhite}];
//    _userNameTF.text = @"15701344579";
    _userNameTF.keyboardType = UIKeyboardTypeAlphabet;
    UIImageView * line1  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width * 0.8, 0.5)];
    line1.backgroundColor = ColorWhite;
    [_userNameTF addSubview:line1];
    line1.bottom = _userNameTF.height;
    
    
    _passwordTF = [[UITextField alloc]init];
    _passwordTF.height = 50;
    _passwordTF.placeholder = @"密码";
    _passwordTF.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_passwordTF];
    _passwordTF.delegate = self;
    _passwordTF.textColor = ColorWhite;
    _passwordTF.font = FontBig;
    _passwordTF.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:_passwordTF.placeholder attributes:@{NSForegroundColorAttributeName:ColorWhite}];
    _passwordTF.keyboardType = UIKeyboardTypeAlphabet;
    UIImageView * line2  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width * 0.8, 0.5)];
    [_passwordTF addSubview:line2];
    line2.backgroundColor = ColorWhite;
    line2.bottom = _passwordTF.height;
    
    
    _loginBtn = [[UIButton alloc]init];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.backgroundColor = ColorTheme;
    [_loginBtn setTitleColor:ColorWhite forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = FontBig;
    [self.view addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _passwordTF.frame = CGRectMake(0, 0, self.view.width * 0.8, 50);
    _passwordTF.center = CGPointMake(self.view.width/2, self.view.height/2);
    
    _userNameTF.frame =CGRectMake(0, 0, self.view.width * 0.8, 50);
    _userNameTF.bottom = _passwordTF.top - 10;
    
    _loginBtn.frame =CGRectMake(0, _passwordTF.bottom + 50, self.view.width * 0.8, 40);
    _userNameTF.centerX =  _loginBtn.centerX = _passwordTF.centerX ;
    
    _imgLogo.width = ScreenWidth * 0.3;
    _imgLogo.bottom = _userNameTF.top - 30;
    _imgLogo.left = _userNameTF.left;

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
    
    

    [ProgressTool show];
    [Request loginWithUserName:_userNameTF.text passWord:[NSString MD5ForLower32Bate:_passwordTF.text] success:^(NSUInteger code, NSString *msg, id data) {
        
        if (code == 200) {
            
            [Request getUserInfo1WithIdOrName:self->_userNameTF.text success:^(NSUInteger code, NSString *msg, id data) {
                [ProgressTool hidden];
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiForLoginSuccess object:nil];
                    
                }else{
                    [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
                }
            } failure:^(NSError *error) {
                [ProgressTool hidden];
                [self.view makeToast:@"个人信息获取失败" duration:2 position:CSToastPositionCenter];
            }];
            
        }else{
            [ProgressTool hidden];
            [self.view makeToast:[NSString stringWithFormat:@"%@:%@",msg,data] duration:2 position:CSToastPositionCenter];
            
        }
    } failure:^(NSError *error) {
        [ProgressTool hidden];
        [self.view makeToast:@"密码验证失败" duration:2 position:CSToastPositionCenter];
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
