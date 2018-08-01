//
//  ChatCellFileView.m
//  YYIM
//
//  Created by Jobs on 2018/8/1.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatCellFileView.h"
@interface ChatCellFileView()
@property (nonatomic,strong)UIImageView * imgView;

@property (nonatomic,strong)UILabel * labelName;
@property (nonatomic,strong)UILabel * labelDesc;

@end
@implementation ChatCellFileView
-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
        
    }
    return self;
    
}
-(void)initUI{
    self.frame = CGRectMake(0, 0, ScreenWidth*0.5, ScreenWidth*0.5*0.3);
    self.backgroundColor =ColorWhite;
    
    
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.height - 20, self.height-20)];
    _imgView.image = [UIImage imageNamed:@"filemanager_folder"];
    [self addSubview:_imgView];
    
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right + 10, _imgView.top, self.width - _imgView.right-20, _imgView.height/2)];
    _labelName.font = FontBig;
    _labelName.textColor = ColorBlack;
    [self addSubview:_labelName];

    
    
    
    _labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right + 10, _imgView.top, self.width - _imgView.right -20, _imgView.height/2)];
    _labelDesc.font = FontBig;
    _labelDesc.textColor = ColorBlack;
    [self addSubview:_labelDesc];
    _labelDesc.bottom = _imgView.bottom;
    
    
}
-(void)setModel:(MsgModel *)model{
    _model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_labelName.text = self->_model.content;
        self->_labelDesc.text = self->_model.content;
    });

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
