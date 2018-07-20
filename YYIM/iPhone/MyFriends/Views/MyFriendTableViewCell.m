//
//  MyFriendTableViewCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MyFriendTableViewCell.h"
#import "PersonManager.h"
#import "UIImage+Helper.h"

@interface MyFriendTableViewCell()
@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel * labelName;
@property (nonatomic,strong)UILabel * labelDesc;
@end
@implementation MyFriendTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    headImg.layer.cornerRadius = headImg.height/2;
    headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:headImg];
    _headImg = headImg;
    

    
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    _labelName.font = FontBig;
    _labelName.textColor = ColorBlack;
    [self.contentView addSubview:_labelName];
    
    
    _labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(10, _labelName.bottom + 10, 100, 20)];
    _labelDesc.font = FontNormal;
    _labelDesc.textColor = ColorBlack;
    [self.contentView addSubview:_labelDesc];

}
-(void)setModel:(MyFriendsModel *)model{
    _model = model;
    
    _headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",_model.HeadName]];
    _labelName.text = [NSString stringWithFormat:@"%@",_model.userName];
    _labelDesc.text = [NSString stringWithFormat:@"%@",_model.UnderWrite];
    
    if (![[[PersonManager share]getStatusWithId:_model.userID] isEqualToString:@"1"]) {
        _headImg.image = [UIImage changeGrayImage:_headImg.image];
    }
    
    [self layoutSubviews];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
    
}
-(void)layout{
    _headImg.left = 10;
    _headImg.top = 10;
    
    _labelName.left = _headImg.right + 10;
    _labelName.bottom = _headImg.centerY ;
    
    _labelDesc.left = _headImg.right + 10;
    _labelDesc.top = _headImg.centerY + 5;
    
    self.ph_Height = _headImg.bottom + 10;
}

@end
