//
//  ChatAddView.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatAddView.h"

@implementation ChatAddView
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

    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    label.font = FontNormal;
    label.textColor = ColorBlack;
    label.text = @"功能";
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
