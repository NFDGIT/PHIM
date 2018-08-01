//
//  PhotoBrowserView.m
//  YYIM
//
//  Created by Jobs on 2018/7/27.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PhotoBrowserView.h"
@interface PhotoBrowserView()
@property (nonatomic,assign)CGRect originRect;
@property (nonatomic,strong)UIImageView * imgView;

@end
@implementation PhotoBrowserView
-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];


    
    
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_imgView];
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)appearFromView:(UIView*)view imgs:(NSArray *)imgs{
    CGRect rect = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
    _originRect = rect;
    
    
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgs[0]]] placeholderImage:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    
    
    _imgView.frame = _originRect;
    [UIView animateWithDuration:0.5 animations:^{
        self->_imgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }];
    
  
    
}


-(void)disAppear{
    [UIView animateWithDuration:0.5 animations:^{
        self->_imgView.frame = self->_originRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];

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
