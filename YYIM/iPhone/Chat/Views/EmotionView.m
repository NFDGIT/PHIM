//
//  EmotionView.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "EmotionView.h"

@implementation EmotionView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, 150);
    }
    return self;
}
-(void)initUI{

    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:scrollView];
    
    
    
    CGFloat imgW = 30;
    CGFloat imgH = 30;
    for (int i = 0; i < 5; i ++) {
        CGFloat imgX = 10 + (imgW + 10)* i;
        CGFloat imgY = 10;
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        [scrollView addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"hello_"];
        
        imgView.userInteractionEnabled = YES;
        imgView.tag = 100+ i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emotionClick:)];
        [imgView addGestureRecognizer:tap];
        
    }
    
    
}

#pragma mark -- 表情的点击事件
-(void)emotionClick:(UITapGestureRecognizer *)tap{
    if (_clickBlock) {
//        UIImageView * imgView = (UIImageView *)tap.view;
        _clickBlock(@"hello_");
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
