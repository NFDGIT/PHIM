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
#import "PersonManager.h"
#import "PhotoBrowserView.h"
#import "ChatCellFileView.h"


static ChatCell *shared = nil;
@interface ChatCell()

@property (nonatomic,strong)UIImageView * headImg;
@property (nonatomic,strong)UILabel     * labelName;

@property (nonatomic,strong)UILabel     * msgContent;


@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UIProgressView * progressView;


@property (nonatomic,strong)ChatCellFileView * fileView;
@end
@implementation ChatCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ChatCell alloc] init];
        [shared initUI];
    });
    return shared;
}


-(void)initUI{
    self.contentView.backgroundColor  =[UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView * headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    headImg.layer.cornerRadius = headImg.height / 2;
    headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:headImg];
    _headImg = headImg;
    headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer * headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgTap:)];
    [headImg addGestureRecognizer:headTap];
    
    
    UILabel * labelName = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right + 10, headImg.top, self.width - headImg.right - 20, 20)];
    labelName.textColor = ColorBlack;
    labelName.font = FontBig;
    [self.contentView addSubview:labelName];
    _labelName = labelName;
    
    
    UILabel * msgContent = [[UILabel alloc]initWithFrame:CGRectMake(headImg.right + 10, headImg.top, self.width - headImg.right - 20, 40)];
    msgContent.textColor = ColorBlack;
    msgContent.font = FontBig;
    [self.contentView addSubview:msgContent];
    msgContent.backgroundColor  =[UIColor colorWithRed:202/255.0 green:231/255.0 blue:254/255.0 alpha:1];
    msgContent.layer.cornerRadius = 8;
    msgContent.layer.masksToBounds = YES;
    _msgContent = msgContent;
    _msgContent.numberOfLines = 0;
    
    
    _imgView = [[UIImageView alloc]init];
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.layer.cornerRadius = 8;
    _imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imgView];
    _imgView.hidden = YES;
    
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
    [_imgView addGestureRecognizer:imgTap];
    
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    
    
    
 
    _progressView.progressTintColor = ColorTheme;
    _progressView.trackTintColor = [UIColor lightGrayColor];
    [_imgView addSubview:_progressView];
    
    
    _fileView = [ChatCellFileView new];
    _fileView.hidden = YES;
    [self.contentView addSubview:_fileView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
}
-(CGFloat)layout{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _msgContent.hidden = YES;
    _imgView.hidden = YES;
    _fileView.hidden = YES;
    
    
    _labelName.hidden = YES;
    
    
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
   
            _msgContent.width = self.width * 0.5;
            [_msgContent sizeToFit];
            _msgContent.width = _msgContent.width + 10;
            _msgContent.height = _msgContent.height + 10;
            _msgContent.textAlignment =NSTextAlignmentCenter;
            
            
            if ([_model.sendId isEqualToString:CurrentUserId]) {
                _msgContent.right = _headImg.left - 10;
                
                _msgContent.top = _headImg.top;
                //                _msgContent.textAlignment = NSTextAlignmentRight;
                
            }else{
                _msgContent.top = _headImg.top;
                _msgContent.left = _labelName.left;
                //                _msgContent.textAlignment = NSTextAlignmentLeft;
            }
            self.ph_Height = _msgContent.bottom + 10;
        }
            break;
        case MsgTypeImage: // 图片消息
        {
            _imgView.hidden = NO;
            NSString * imgUrl = [NSString stringWithFormat:@"%@",_model.imageUrl];

            _imgView.width = ScreenWidth*0.5;
            _imgView.height = ScreenWidth*0.5;


            if ([_model.sendId isEqualToString:CurrentUserId]) {
                _imgView.right = _labelName.right;
                _imgView.top = _headImg.top;
                
            }else{
                _imgView.left = _labelName.left;
                _imgView.top = _headImg.top;
            }
            
            
            _progressView.center = CGPointMake(_imgView.width/2, _imgView.height/2);
            self.ph_Height = _imgView.bottom + 10;
        }
            break;
        case MsgTypeFile: // 文件消息
        {
            
            _fileView.hidden = NO;
            
            _fileView.top = _headImg.top;
            if ([_model.sendId isEqualToString:CurrentUserId]) {
                _fileView.right = _headImg.left -10;
            }else{
                _fileView.left = _headImg.right + 10;
            }
            
            self.ph_Height = _fileView.bottom + 10;
        }
            break;

            
        default:
            break;
    }
    
    
    if (self.ph_Height < _headImg.bottom + 10) {
        self.ph_Height = _headImg.bottom + 10;
    }
    
    
    return self.ph_Height;
}

-(void)setModel:(MsgModel *)model{
    _model = model;
    
   
    UserInfoModel * infoModel = [[PersonManager share] getModelWithId:_model.sendId];
    _headImg.image = [UIImage imageNamed:@"touxiang_default"];
    UIImage * headImage = [UIImage imageNamed:[NSString stringWithFormat:@"LocalHeadIcon.bundle/%@.jpg",infoModel.HeadName]];
    if (headImage) {
        _headImg.image = headImage;
    }
    _progressView.hidden = YES;


    
    
    
    switch (_model.msgType) {
        case MsgTypeText:
        {
            _msgContent.attributedText = [RishTextAdapter getAttributedStringWithString:_model.content];
        }
            break;
        case MsgTypeImage:
        {
            _progressView.hidden = NO;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.imageUrl]] placeholderImage:[UIImage imageNamed:@"chat_默认图"] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                float percent = (float)receivedSize/(float)expectedSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_progressView.progress = percent;
                });
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                self->_progressView.hidden = YES;
            }];
        }
            break;
        case MsgTypeFile:
        {
                _fileView.model = _model;
            
        }
            break;
            
        default:
            break;
    }



    

    
    
    
    
    [self layoutSubviews];
    

}

#pragma mark -- 点击事件
-(void)headImgTap:(UITapGestureRecognizer *)tap{
    if (_headClickBlock) {
        _headClickBlock(self.indexPath);
    }
    
    
}
-(void)imgTap:(UITapGestureRecognizer *)tap{
    
    PhotoBrowserView * browser = [PhotoBrowserView new];
    [browser appearFromView:tap.view imgs:@[_model.imageUrl]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(CGFloat)getHeightWithModel:(MsgModel *)model{


    
    CGFloat height = 60 + 20;
    switch (model.msgType) {
        case MsgTypeText:
        {
            UILabel * msgContent = [[UILabel alloc]init];
            msgContent.numberOfLines = 0;
            msgContent.font = FontBig;
            msgContent.width = ScreenWidth * 0.5;
            msgContent.height = 20;
            msgContent.attributedText = [RishTextAdapter getAttributedStringWithString:model.content];
            [msgContent sizeToFit];
            msgContent.width = msgContent.width + 10;
            msgContent.height = msgContent.height + 10;
   
            height = msgContent.height + 20;
        }
            break;
        case MsgTypeFile:
            height =  60 + 20;
            break;
        case MsgTypeImage:
            height =  ScreenWidth*0.5 + 20;
            break;
        default:
            break;
    }
    if (height<80) {
        height = 80;
    }
    
    
    return height;

}




@end
