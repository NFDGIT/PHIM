//
//  ChatAddView.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatAddView.h"
#import "PHImagePickerController.h"
#import "FileManagerViewController.h"
#import "TabBarController.h"

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
    
    
    
    CGFloat imgW = (ScreenWidth - 20)/4 -20;
    CGFloat imgH = imgW;
    

    
    for (int i = 0; i < 3; i ++) {
        

        
        CGFloat imgX = 0;
        CGFloat imgY = 0;
        
        
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
        
        
        
        imgView.center = CGPointMake(_scrollView.width/2, _scrollView.height/2);

        if (i == 0) {
            
            imgView.image = [UIImage imageNamed:@"chatadd_camera"];
            imgView.right = imgView.left - 10;
        }
        if (i == 1) {
            imgView.image = [UIImage imageNamed:@"chatadd_finder"];
        }
        if (i == 2) {
            imgView.image = [UIImage imageNamed:@"chatadd_business"];
            imgView.left = imgView.right + 10;
        }
    }
    
    
    
    
    
}

#pragma mark -- 点击事件
-(void)imgClick:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 100) {
        PHImagePickerController * picker = [PHImagePickerController new];
        picker.allowsEditing = NO;
        picker.block = ^(UIImage *image) {
            if (self->_clickBlock) {
                self->_clickBlock(ChatAddTypeImage,image);
            }
        };
        [[TabBarController share] presentViewController:picker animated:YES completion:^{
        }];
    }
    if (tap.view.tag == 101) {
        FileManagerViewController * fileManager = [FileManagerViewController new];
        [fileManager show];
        fileManager.selectBlock = ^(NSURL *url) {
            if (self->_clickBlock) {
                self->_clickBlock(ChatAddTypeFile,url);
            }
        };

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
