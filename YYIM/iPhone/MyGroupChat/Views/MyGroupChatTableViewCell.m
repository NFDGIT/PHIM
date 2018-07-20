//
//  MyGroupChatTableViewCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/18.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyGroupChatTableViewCell.h"
@interface MyGroupChatTableViewCell()
@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel * labelName;
@property (nonatomic,strong)UILabel * labelDesc;
@end
@implementation MyGroupChatTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    _headImg.layer.cornerRadius = _headImg.height/2;
    _headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImg];
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    _labelName.font = FontBig;
    _labelName.textColor = ColorBlack;
    [self.contentView addSubview:_labelName];
    
    
    _labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    _labelDesc.font = FontSmall;
    _labelDesc.textColor = ColorBlack;
    [self.contentView addSubview:_labelDesc];
}
-(void)setModel:(MyGroupChatModel *)model{
    _model = model;

    
    _headImg.image = [UIImage imageNamed:@"群组_default"];
    _labelName.text = [NSString stringWithFormat:@"%@",_model.groupName];
    _labelDesc.text = [NSString stringWithFormat:@"%@",_model.groupDep];
    [self layoutSubviews];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
}
-(void)layout{
    _headImg.left = 10;
    _headImg.top = 10;
    
    _labelName.left = _headImg.right + 10;
    _labelName.width = self.width - _headImg.right - 20;
    _labelName.top = 10;
    
    
    _labelDesc.top = _labelName.bottom  +10;
    _labelDesc.left = _labelName.left;
    _labelDesc.width = self.width - _labelDesc.left;
    
    self.ph_Height = _labelDesc.bottom  +10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
