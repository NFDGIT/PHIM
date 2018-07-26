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
    scrollView.backgroundColor  =[UIColor whiteColor];
    [self addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    _scrollView = scrollView;
    
    
    NSInteger count = 95;
    
    CGFloat baseX = 10;
    CGFloat baseY = 10;
    
    
    CGFloat imgW = 30;
    CGFloat imgH = 30;
    
    NSInteger column = (_scrollView.width -baseX)/(imgW + 10);
    NSInteger row = (_scrollView.height - baseY)/(imgH + 10);
    
    
    NSInteger totalPage = count / (column * row) + 1;
    
    NSInteger tag = 0;
    for (int i = 0; i < 90; i ++) {
        
        
        baseX =  10  +(_scrollView.width * (i/ (row * column)));
        baseY = 10;
        
        CGFloat imgX = baseX  + (imgW + 10)* (i%column) ;
        CGFloat imgY = baseY + (imgH + 10)* ((i/column) % row);
        

        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        [_scrollView addSubview:imgView];
        imgView.userInteractionEnabled = YES;

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emotionClick:)];
        [imgView addGestureRecognizer:tap];
       
        
        if ((i + 1) % (column * row) == 0) {
//            imgView.hidden = YES;
//            imgView.backgroundColor  =[UIColor lightGrayColor];
//            UITapGestureRecognizer * deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteClick)];
//            [imgView addGestureRecognizer:deleteTap];
        }else{
            imgView.tag = 100 + tag;
            tag ++ ;
            
        }
       
    }
    
    
    for (int i = 0; i < totalPage; i ++) {
        
        
        baseX =  10  +(_scrollView.width * i);
        baseY = 10;
        
        CGFloat imgX = baseX  + (imgW + 10)* ((row * column -1)%column) ;
        CGFloat imgY = baseY + (imgH + 10)* (((row * column -1)/column) % row);
    
        UIButton * deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        [deleBtn setImage:[UIImage imageNamed:@"emotion_删除"] forState:UIControlStateNormal];
        [_scrollView addSubview:deleBtn];
        [deleBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * totalPage, _scrollView.height);
    
}
-(void)addDeleBtn{
    
    
    
}


-(void)refreshUI{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0 ; i < 95; i++) {
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
-(void)deleteClick{
    if (_deleteBlock) {
        _deleteBlock();
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
