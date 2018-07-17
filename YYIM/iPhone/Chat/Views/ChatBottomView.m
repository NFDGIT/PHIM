//
//  ChatBottomView.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatBottomView.h"
@interface ChatBottomView()
@property (nonatomic,strong)UIScrollView * scrollView;

@end
@implementation ChatBottomView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UIScrollView * scrollView =   [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:scrollView];
    scrollView.scrollEnabled = NO;
    _scrollView = scrollView;
    
    EmotionView * emotionView = [[EmotionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [scrollView addSubview:emotionView];
    _emotionView = emotionView;
    
    ChatAddView * chatadd = [[ChatAddView alloc]initWithFrame:CGRectMake(emotionView.right, 0, self.width, self.height)];
    [scrollView addSubview:chatadd];
    _addView = chatadd;
    
    scrollView.contentSize = CGSizeMake(chatadd.right, scrollView.height);
    scrollView.contentOffset = CGPointMake(scrollView.width, 0);
    
}
-(void)setPage:(NSUInteger)page{
    _page = page;
    _scrollView.contentOffset = CGPointMake(_scrollView.width * _page, 0);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
