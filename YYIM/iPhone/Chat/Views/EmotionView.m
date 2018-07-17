//
//  EmotionView.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "EmotionView.h"
@interface EmotionView()
@property (nonatomic,strong)UIScrollView * scrollView;
@end
@implementation EmotionView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         [self initUI];
        [self refreshUI];

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
    scrollView.pagingEnabled = YES;
    _scrollView = scrollView;
    
    
    
    
    CGFloat baseX = 10;
    CGFloat baseY = 10;
    
    
    CGFloat imgW = 30;
    CGFloat imgH = 30;
    
    NSInteger column = (_scrollView.width -baseX)/(imgW + 10);
    NSInteger row = (_scrollView.height - baseY)/(imgH + 10);
    
    for (int i = 0; i < 90; i ++) {
        baseX =  10  +(_scrollView.width * (i/ (row * column)));
        baseY = 10;
        
        
        CGFloat imgX = baseX  + (imgW + 10)* (i%column) ;
        CGFloat imgY = baseY + (imgH + 10)* ((i/column) % row);
        
        
        
        
        
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        [_scrollView addSubview:imgView];
        
//        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Emotion.bundle/%d.gif",i]];
        imgView.userInteractionEnabled = YES;
        imgView.tag = 100+ i;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emotionClick:)];
        [imgView addGestureRecognizer:tap];
        
        
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.width * (1 + 1), _scrollView.height);
    
    

}
-(void)refreshUI{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0 ; i < 90; i++) {
            UIImage * image =  [UIImage imageNamed:[NSString stringWithFormat:@"Emotion.bundle/%d.gif",i]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView * img = [self->_scrollView viewWithTag:i + 100];
                img.image = image;
            });
        }
    });

}

-(void)layout{

}

#pragma mark -- 表情的点击事件
-(void)emotionClick:(UITapGestureRecognizer *)tap{
    UIImageView * imgView = (UIImageView *)(tap.view);
    
    NSString * emotion = [NSString stringWithFormat:@"[:f%ld]",(long)imgView.tag-100];

    if (_clickBlock) {
        _clickBlock(emotion);
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
