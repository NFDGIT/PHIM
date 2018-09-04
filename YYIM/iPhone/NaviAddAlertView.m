//
//  NaviAddAlertView.m
//  YYIM
//
//  Created by Jobs on 2018/7/25.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "NaviAddAlertView.h"
@interface NaviAddAlertView()
@property (nonatomic,strong)UIButton * backView;

@end
@implementation NaviAddAlertView


-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _backView  =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [_backView addTarget:self action:@selector(disAppear) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.frame  =CGRectMake(0, 0, 170, 150);

    self.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:self];
    

    CGFloat btnH = 50;
    for (int i = 0; i < 3; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, btnH*i, self.width, btnH)];
        [self addSubview:btn];
        

        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleColor:ColorBlack forState:UIControlStateNormal];
        [btn setTitleColor:ColorRed forState:UIControlStateSelected];
        
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.exclusiveTouch = YES;
        self.height = btn.bottom;
        
        switch (i) {
            case 0:
                [btn setTitle:@" 创建群聊" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"naviadd_creategroup"] forState:UIControlStateNormal];
                break;
            case 1:
                [btn setTitle:@" 加好友" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"naviadd_add"] forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@" 加群" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"naviadd_add"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    
    
    self.top = NaviHeight;
    self.right = ScreenWidth - 10;
    
    
}

-(void)btnClick:(UIButton *)sender{

    
    
    
    if (self.clickBlock) {
        self.clickBlock(sender.tag - 100);
        [self disAppear];
    }
    


}



-(void)refreshUI{
//    for (int i = 0;  i < 6; i ++) {
//        UIButton * btn = [self viewWithTag:100 + i];
//        btn.selected = _userStatus == i;
//    }
//    
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
