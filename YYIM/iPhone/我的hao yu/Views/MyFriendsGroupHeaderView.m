//
//  MyFriendsGroupHeaderView.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyFriendsGroupHeaderView.h"
@interface MyFriendsGroupHeaderView()
@property (nonatomic,strong)UIButton * btnName;

@property (nonatomic,strong)UILabel  * labelCount;
@end
@implementation MyFriendsGroupHeaderView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}
-(void)initUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    
    
    _btnName = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    [_btnName setTitleColor:ColorBlack forState:UIControlStateNormal];
    _btnName.titleLabel.font = FontBig;
    _btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:_btnName];
    [_btnName setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateSelected];
    [_btnName setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    [_btnName addTarget:self action:@selector(expandedClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _labelCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    _labelCount.textColor = ColorBlack;
    _labelCount.font = FontNormal;
    _labelCount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelCount];
    
}
-(void)layout{
    self.contentView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    _btnName.left = 10;
    _btnName.centerY = self.height / 2;
    
    _labelCount.right = self.width - 10;
    _labelCount.centerY =self.height / 2;
    
    
    
    
}


-(void)setModel:(MyFriendsGroupModel *)model{
    _model = model;
    
    [_btnName setTitle:[NSString stringWithFormat:@"%@",_model.Dicationary] forState:UIControlStateNormal];
    _btnName.selected = _model.Expanded;
    
    _labelCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)_model.Friend.count];
    
    [self layout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
}
#pragma mark -- 点击事件
-(void)expandedClick{
    if (_clickBlock) {
        _clickBlock(self.section);
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
