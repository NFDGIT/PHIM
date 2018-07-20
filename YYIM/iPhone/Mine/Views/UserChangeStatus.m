//
//  UserChangeStatus.m
//  YYIM
//
//  Created by Jobs on 2018/7/20.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "UserChangeStatus.h"
@interface UserChangeStatus()
@property (nonatomic,strong)UIButton * backView;

@end
@implementation UserChangeStatus
-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _backView  =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _backView.backgroundColor = [UIColor clearColor];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame  =CGRectMake(0, 0, 100, 150);
    self.center = CGPointMake(_backView.width/2, _backView.height/2);
    self.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:self];
    

    
    
    CGFloat btnH = 30;
    NSArray * titles = @[@"离线",@"在线",@"隐身",@"离开",@"繁忙",@"勿扰"];
    for (int i = 0; i < titles.count; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnH*i, self.width, btnH)];
        [self addSubview:btn];
        
        NSString * title = titles[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:ColorBlack forState:UIControlStateNormal];
        [btn setTitleColor:ColorRed forState:UIControlStateSelected];
        
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
        btn.exclusiveTouch = YES;
        self.height = btn.bottom;
    }
    self.centerY = _backView.height / 2;
    
    
}

-(void)btnClick:(UIButton *)sender{
    self.userStatus = sender.tag - 100;
    if (_changeStatusBlock) {
        _changeStatusBlock(self.userStatus);
    }
}

-(void)setUserStatus:(UserStatus)userStatus{
    _userStatus = userStatus;
    
    [self refreshUI];
}


-(void)refreshUI{
    for (int i = 0;  i < 6; i ++) {
        UIButton * btn = [self viewWithTag:100 + i];
        btn.selected = _userStatus == i;
    }
    
}


-(void)appear{
    [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    
    
}
-(void)disAppear{
    [_backView removeFromSuperview];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
