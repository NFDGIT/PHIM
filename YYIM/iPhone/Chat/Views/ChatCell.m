//
//  ChatCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ChatCell.h"
#import "RishTextAdapter.h"
#import "NSDictionary+Helper.h"

@interface ChatCell()

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel     * labelName;

@property (nonatomic,strong)UILabel     * msgContent;


@property (nonatomic,strong)UIImageView * imgView;
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
    
    
    
    _imgView = [[UIImageView alloc]init];
    _imgView.layer.cornerRadius = 5;
    _imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imgView];
    _imgView.hidden = YES;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _msgContent.hidden = YES;
    _imgView.hidden = YES;
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"touxiang_default"]];
    
    _labelName.text = _model.sendId;
    
    

    
    
    if ([_model.sendId isEqualToString:CurrentUserId]) {
        _headImg.right = self.width - 10;
        _labelName.right = _headImg.left - 10;
        _labelName.textAlignment = NSTextAlignmentRight;

    }else{
        _headImg.left = 10;
        
        _labelName.left = _headImg.right + 10;
        _labelName.top = _headImg.top;
        _labelName.textAlignment = NSTextAlignmentLeft;

    }
  
    
    switch (_model.msgType) {
        case MsgTypeText:// 文本消息
        {
            _msgContent.hidden = NO;
            _msgContent.attributedText = [RishTextAdapter getAttributedStringWithString:_model.content];
            _msgContent.width = self.width - _headImg.right - 100;
            [_msgContent sizeToFit];
            
            
            if ([_model.sendId isEqualToString:CurrentUserId]) {
                _msgContent.right = _headImg.left - 10;
                _msgContent.textAlignment = NSTextAlignmentRight;
                _msgContent.top = _labelName.bottom + 10;
                
            }else{
                _msgContent.top = _labelName.bottom + 10;
                _msgContent.left = _labelName.left;
                _msgContent.textAlignment = NSTextAlignmentLeft;
            }
            
            self.ph_Height = _msgContent.bottom + 10;
        }
            break;
        case MsgTypeImage: // 图片消息
        {
            _imgView.hidden = NO;
            NSString * imgUrl = [NSString stringWithFormat:@"%@",_model.imageUrl];
            NSDictionary * paramDic = [NSDictionary getParamDicWithUrl:imgUrl];
            
            
            _imgView.width = 200;
            _imgView.height = 200;
            if ([paramDic.allKeys containsObject:@"width"] && [paramDic.allKeys containsObject:@"height"]) {
                NSString * width = [NSString stringWithFormat:@"%@",paramDic[@"width"]];
                NSString * height = [NSString stringWithFormat:@"%@",paramDic[@"height"]];
                
                _imgView.width = width.floatValue;
                _imgView.height = height.floatValue;
            }
            
            [_imgView sd_setImageWithURL:[NSURL URLWithString:@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=992967123,470419484&fm=27&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"chat_默认图"]];
//        http://img1.imgtn.bdimg.com/it /?u=3920398476,1501488149&fm=27&gp=0.jpg&width=200&height=300
            
            if ([_model.sendId isEqualToString:CurrentUserId]) {
                _imgView.right = _labelName.right;
                _imgView.top = _labelName.bottom + 10;

            }else{
                _imgView.left = _labelName.left;
                _imgView.top = _labelName.bottom + 10;
                
            }
            
            self.ph_Height = _imgView.bottom + 10;
        }
            break;
            
        default:
            break;
    }
    

    
   


    
    
    
    if (self.ph_Height < _headImg.bottom + 10) {
        self.ph_Height = _headImg.bottom + 10;
    }
    
}


-(void)setModel:(MsgModel *)model{
    _model = model;
    

    
    
    [self layoutSubviews];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
