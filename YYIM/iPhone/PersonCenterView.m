//
//  PersonCenterView.m
//  YYIM
//
//  Created by Jobs on 2018/7/24.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PersonCenterView.h"
#import "PersonDetailViewController.h"
#import "UpdatePasswordViewController.h"
#import "TabBarController.h"
#import "NSDate+Helper.h"

static PersonCenterView *shared = nil;
@interface PersonCenterView()
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)UIImageView * headBackImg;
@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel     * labelDate;
@property (nonatomic,strong)UILabel     * labelName;
@property (nonatomic,strong)UILabel     * labelDesc;


@property (nonatomic,strong)UIButton    * btnLogout;


@end
@implementation PersonCenterView
+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[PersonCenterView alloc] init];
        [shared initUI];
    });
    return shared;
}

-(void)initUI{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.right = 0;
//    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    [UIApplication sharedApplication].keyWindow.backgroundColor = ColorWhite;
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    
    [[TabBarController share].view addSubview:self];
    
    
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipe];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [self addGestureRecognizer:tap];
    
    
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.8, ScreenHeight)];
    scrollView.backgroundColor = ColorWhite;
    scrollView.exclusiveTouch = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [scrollView addGestureRecognizer:tap1];
    
    
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    
    
    
    
    
    {
        UIImageView * headBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollView.width , ScreenHeight * 0.3)];
        headBackImg.backgroundColor = ColorTheme;
        headBackImg.userInteractionEnabled = YES;
        headBackImg.image = [UIImage imageNamed:@"personcenter_headback"];
        [scrollView addSubview:headBackImg];
        _headBackImg = headBackImg;
        
        UILabel * labelDate =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        labelDate.textColor  = ColorWhite;
        labelDate.font = FontBig;
        [headBackImg addSubview:labelDate];
        labelDate.textAlignment = NSTextAlignmentRight;
        _labelDate = labelDate;
        
        
        
        UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        headImg.layer.cornerRadius = headImg.height/2;
        headImg.layer.masksToBounds = YES;
        headImg.userInteractionEnabled = YES;
        [headBackImg addSubview:headImg];
        _headImg = headImg;
        UITapGestureRecognizer * headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToDetail)];
        [headImg addGestureRecognizer:headTap];
        
        UILabel * labelName =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        labelName.textColor  = ColorWhite;
        labelName.font = [UIFont systemFontOfSize:30 weight:YES];
        [headBackImg addSubview:labelName];
        _labelName = labelName;
        
        
        UILabel * labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        labelDesc.textColor  = ColorWhite;
        labelDesc.font = FontBig;
        [headBackImg addSubview:labelDesc];
        _labelDesc = labelDesc;
        
        
        
        
        
        for (int i = 0; i < 3; i ++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, headBackImg.bottom + 30 + 50 * i , scrollView.width, 50)];
            [btn setTitleColor:ColorBlack forState:UIControlStateNormal];
            [btn setTitle:@"退出登陆" forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.left = 20;
            [scrollView addSubview:btn];
            switch (i) {
                case 0:
                    [btn setImage:[UIImage imageNamed:@"personcenter_changeaccount"] forState:UIControlStateNormal];
                    [btn setTitle:@"  切换账号" forState:UIControlStateNormal];
                    break;
                case 1:
                    [btn setImage:[UIImage imageNamed:@"personcenter_changepassword"] forState:UIControlStateNormal];
                    [btn setTitle:@"  修改密码" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(jumpToUpdatePassword) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    [btn setImage:[UIImage imageNamed:@"personcenter_logout"] forState:UIControlStateNormal];
                    [btn setTitle:@"  退出登录" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                default:
                    break;
            }
        }
        
    
        
    }
}
-(void)refreshUI{
     _headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",CurrentUserIcon]];
    _labelName.text = [NSString stringWithFormat:@"%@",CurrentUserName];
    _labelDesc.text = [NSString stringWithFormat:@"%@",CurrentUserUnderWrite];
    _labelDate.text = [NSString stringWithFormat:@"%ld/%ld %@",(long)[NSDate getMonth],(long)[NSDate getDay],[NSDate getWeekDay]];
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self layout];
}
-(void)layout{
    _labelDate.top = StatusBarHeight + 10;
    _labelDate.right = _scrollView.width - 20;
    
    _labelDesc.bottom = _headBackImg.height - 30;
    _labelDesc.left = 20;
    
    _headImg.bottom = _labelDesc.top - 10;
    _headImg.left = 20;
    
    _labelName.left = _headImg.right + 10;
    _labelName.centerY = _headImg.centerY;
    
}

-(void)appear{
    [self.superview bringSubviewToFront:self];
    [self refreshUI];
    
    self.right = 0.2 * ScreenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        self.left = 0;
//        ((UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController]).view.left = ScreenWidth * 0.8;
    }completion:^(BOOL finished) {

    }];
}
-(void)disAppear{
    
   
    [UIView animateWithDuration:0.5 animations:^{
        self.right = 0.2 * ScreenWidth;
//        ((UITabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController]).view.left = 0;
    }completion:^(BOOL finished) {
        self.right = 0;
    }];
    
}
#pragma mark -- 点击事件
-(void)swipe:(UISwipeGestureRecognizer *)swipe{
    [self disAppear];
}

-(void)tap{
}
-(void)logout{
//
    [PHAlert showConfirmWithTitle:@"提示" message:@"确定要退出登录？" block:^(BOOL sure){
        if (sure) {
             [self disAppear];
             [((AppDelegate *)[UIApplication sharedApplication].delegate) logout];
        }else{
//            [self appear];
        }
       
    }];
    
    
}
-(void)jumpToUpdatePassword{
    [self disAppear];
    
    UpdatePasswordViewController * update = [UpdatePasswordViewController new];
    [((UINavigationController *)([((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController) viewControllers].firstObject)) pushViewController:update animated:YES];
    
}
-(void)jumpToDetail{
    [self disAppear];
    
    PersonDetailViewController * detail = [PersonDetailViewController new];
    detail.Id = CurrentUserId;
    [((UINavigationController *)([((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController) viewControllers].firstObject)) pushViewController:detail animated:YES];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
