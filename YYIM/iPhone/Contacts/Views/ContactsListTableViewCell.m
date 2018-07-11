//
//  ContactsListTableViewCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ContactsListTableViewCell.h"



@interface ContactsListTableViewCell()
@property (nonatomic,strong)UILabel * labelName;
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
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200 , 50)];
    _labelName.font = FontNormal;
    _labelName.textColor = ColorBlack;
    [self.contentView addSubview:_labelName];
    
}

#pragma mark -- model set
-(void)setModel:(ContactsListModel *)model{
    _model = model;

    
    
    _labelName.text = _model.Text;
    _labelName.left = _model.level.count * 20;
    
    
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
