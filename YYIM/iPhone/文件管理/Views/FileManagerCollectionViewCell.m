//
//  FileManagerCollectionViewCell.m
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "FileManagerCollectionViewCell.h"
@interface FileManagerCollectionViewCell()
@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UILabel *     labelName;

@end
@implementation FileManagerCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [self.contentView addSubview:_imgView];
    self.backgroundColor = ColorWhite;
    
    
    
    
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _labelName.textColor = ColorBlack;
    _labelName.font = FontBig;
    _labelName.bottom = self.height;
    [self.contentView addSubview:_labelName];

    
    
    
    
    
}

-(void)setModel:(FileManagerModel *)model{
    _model = model;
    
    _labelName.text = _model.fileName;
    NSString *  fileType = _model.fileAttributes[NSFileType];
    if ([fileType isEqualToString:NSFileTypeDirectory]) {
        _imgView.image = [UIImage imageNamed:@"filemanager_folder"];
    }else{
        _imgView.image = [UIImage imageNamed:@"filemanager_file"];
    }
    
    
}
@end
