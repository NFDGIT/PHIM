//
//  ContactsListTableViewCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ContactsListTableViewCell.h"



@interface ContactsListTableViewCell()
@property (nonatomic,strong)UIButton  * btnName;
@end
@implementation ContactsListTableViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self  initUI];
    }
    return self;
}
-(void)initUI{
    _btnName = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200 , 50)];
    _btnName.titleLabel.font = FontNormal;
    [_btnName setTitleColor:ColorBlack forState:UIControlStateNormal];
    _btnName.userInteractionEnabled = NO;
    _btnName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.contentView addSubview:_btnName];
    
}

#pragma mark -- model set
-(void)setModel:(ContactsListModel *)model{
    _model = model;

    
    
    [_btnName setTitle:[NSString stringWithFormat:@"%@",model.Text] forState:UIControlStateNormal];
    if (_model.Nodes.count != 0) {
        [_btnName setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateSelected];
        [_btnName setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
        _btnName.selected = _model.Expanded;
    }else{
        [_btnName setImage:nil forState:UIControlStateNormal];
        [_btnName setImage:nil forState:UIControlStateSelected];
        
    }
    
    
    _btnName.left = _model.level.count * 20;
    
    self.ph_Height = _btnName.bottom + 10;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
