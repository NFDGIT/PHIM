//
//  ChatCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatCell.h"
#import "RishTextAdapter.h"

@interface ChatCell()

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel     * labelName;

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
    self.contentView.backgroundColor  =[UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    headImg.layer.cornerRadius = headImg.height / 2;
    headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:headImg];
    _headImg = headImg;
    
    
    
    UILabel * labelName = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right + 10, headImg.top, self.width - headImg.right - 20, 20)];
    labelName.textColor = ColorBlack;
    labelName.font = FontBig;
    [self.contentView addSubview:labelName];
    _labelName = labelName;
    
    
    UILabel * msgContent = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right + 10, headImg.top, self.width - headImg.right - 20, 40)];
    msgContent.textColor = ColorBlack;
    msgContent.font = FontNormal;
    [self.contentView addSubview:msgContent];
    _msgContent = msgContent;
    _msgContent.numberOfLines = 0;
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    

    
    
    
    if ([_model.sendId isEqualToString:CurrentUserId]) {
        _headImg.right = self.width - 10;
        
        
        
        _labelName.right = _headImg.left - 10;
        _labelName.textAlignment = NSTextAlignmentRight;
        
        
        _msgContent.right = _headImg.left - 10;
        _msgContent.textAlignment = NSTextAlignmentRight;
        _msgContent.top = _labelName.bottom + 10;
        
        
        

    }else{
        _headImg.left = 10;
        
        
        
        _labelName.left = _headImg.right + 10;
        _labelName.top = _headImg.top;
        _labelName.textAlignment = NSTextAlignmentLeft;
        
        
        
        _msgContent.top = _labelName.bottom + 10;
        _msgContent.left = _labelName.left;
        _msgContent.textAlignment = NSTextAlignmentLeft;
    }


    
    
    self.ph_Height = _msgContent.bottom + 10;
    if (self.ph_Height < _headImg.bottom + 10) {
        self.ph_Height = _headImg.bottom + 10;
    }
    
}


-(void)setModel:(MsgModel *)model{
    _model = model;
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"touxiang_default"]];
    
    _labelName.text = model.sendId;
//    _msgContent.text= model.content;
    _msgContent.attributedText = [RishTextAdapter getAttributedStringWithString:_model.content];
    
    
    _msgContent.width = self.width - _headImg.right - 100;
    [_msgContent sizeToFit];
    
    

    
    [self layoutSubviews];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
