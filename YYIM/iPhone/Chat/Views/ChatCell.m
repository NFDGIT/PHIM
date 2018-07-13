//
//  ChatCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatCell.h"
@interface ChatCell()

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel     * msgContent;
@end
@implementation ChatCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
    
}
-(void)initUI{
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    headImg.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:headImg];
    _headImg = headImg;
    
    
    UILabel * msgContent = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right + 10, headImg.top, self.width - headImg.right - 20, 40)];
    msgContent.textColor = ColorBlack;
    msgContent.font = FontNormal;
    [self.contentView addSubview:msgContent];
    _msgContent = msgContent;
    
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if ([_model.Id isEqualToString:@"1"]) {
        _headImg.right = self.width - 10;
        _msgContent.right = _headImg.left - 10;
        _msgContent.textAlignment = NSTextAlignmentRight;

    }else{
        _headImg.frame = CGRectMake(10, 10, 60, 60);
        _msgContent.frame =CGRectMake(_headImg.right + 10, _headImg.top, self.width - _headImg.right - 20, 40);
        _msgContent.textAlignment = NSTextAlignmentLeft;
    }
    
    
}


-(void)setModel:(MsgModel *)model{
    _model = model;
    
    
    _msgContent.text= model.msg;
    
    self.ph_Height = _headImg.bottom + 10;
    
    [self layoutSubviews];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
