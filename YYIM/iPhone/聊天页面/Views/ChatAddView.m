//
//  ChatAddView.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatAddView.h"
#import "PHImagePickerController.h"

@interface ChatAddView()
@property (nonatomic,strong)UIScrollView * scrollView;
@end
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
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    scrollView.backgroundColor  =[UIColor whiteColor];
    [self addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    _scrollView = scrollView;
    
    
    
    
    NSInteger count = 95;
    
    CGFloat baseX = 30;
    CGFloat baseY = 30;
    
    CGFloat spaceX = 30;
    CGFloat spaceY = 30;
    
    
    CGFloat imgW = (ScreenWidth - spaceX)/4 -spaceX;
    CGFloat imgH = imgW;
    
    NSInteger column = (_scrollView.width -baseX)/(imgW + spaceX);
    NSInteger row = (_scrollView.height - baseY)/(imgH + spaceY);
    
    
    NSInteger totalPage = count / (column * row) + 1;
    
    NSInteger tag = 0;
    for (int i = 0; i < 5; i ++) {
        
        
        baseX =  30  +(_scrollView.width * (i/ (row * column)));
        baseY = 30;
        
        CGFloat imgX = baseX  + (imgW + spaceX)* (i%column) ;
        CGFloat imgY = baseY + (imgH + spaceY)* ((i/column) % row);
        
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
        imgView.layer.cornerRadius = 10;
        imgView.layer.masksToBounds = YES;
        imgView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1].CGColor;
        imgView.layer.borderWidth = 1;
        [_scrollView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeCenter;
        imgView.tag = i + 100;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        [imgView addGestureRecognizer:tap];
        if (i == 0) {
            imgView.image = [UIImage imageNamed:@"chat_add_图片"];
        }
    }
    
    
//    for (int i = 0; i < totalPage; i ++) {
//
//
//        baseX =  10  +(_scrollView.width * i);
//        baseY = 10;
//
//        CGFloat imgX = baseX  + (imgW + 10)* ((row * column -1)%column) ;
//        CGFloat imgY = baseY + (imgH + 10)* (((row * column -1)/column) % row);
//
//        UIButton * deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
//        [deleBtn setImage:[UIImage imageNamed:@"emotion_删除"] forState:UIControlStateNormal];
//        [_scrollView addSubview:deleBtn];
//        [deleBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//
    
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * totalPage, _scrollView.height);
    
}

#pragma mark -- 点击事件
-(void)imgClick:(UITapGestureRecognizer *)tap{
    
    PHImagePickerController * picker = [PHImagePickerController new];
    picker.block = ^(UIImage *image) {
        if (self->_clickBlock) {
            self->_clickBlock(ChatAddTypeImage,image);
        }
    };
    
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:^{
    }];
    
  
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
