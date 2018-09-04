//
//  PhotoBrowserView.m
//  YYIM
//
//  Created by Jobs on 2018/7/27.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "PhotoBrowserView.h"
#import "ProgressTool.h"
#import "FileManager.h"
#import <Photos/Photos.h>

@interface PhotoBrowserView()
@property (nonatomic,assign)CGRect originRect;
@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)NSArray * imgs;

@end
@implementation PhotoBrowserView
-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disAppear)];
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];


    
    
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_imgView];
    _imgView.userInteractionEnabled = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIButton * btnDownload = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [self addSubview:btnDownload];
    [btnDownload setTitleColor:ColorWhite forState:UIControlStateNormal];
    btnDownload.titleLabel.font = FontBig;
    [btnDownload setTitle:@"下载" forState:UIControlStateNormal];
    btnDownload.bottom = self.height - 30;
    btnDownload.right = self.width - 30;
    [btnDownload addTarget:self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
}
-(void)appearFromView:(UIView*)view imgs:(NSArray *)imgs{
    _imgs = imgs;
    CGRect rect = [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
    _originRect = rect;
    
    
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgs[0]]] placeholderImage:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    
    
    _imgView.frame = _originRect;
    [UIView animateWithDuration:0.5 animations:^{
        self->_imgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }];
    
  
    
}


-(void)disAppear{
    [UIView animateWithDuration:0.5 animations:^{
        self->_imgView.frame = self->_originRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}
#pragma mark -- 点击事件
-(void)downLoad{

    [ProgressTool showProgressWithText:@"保存中"];
    [Request downloadImage:[NSURL URLWithString:_imgs.firstObject] progress:^(float progress) {
        [ProgressTool setProgress:progress];
    } success:^(NSUInteger code, NSString *msg, id data) {

        UIImage * image = (UIImage *)data;
        [FileManager saveImageToResourceFolder:image];
        
//        __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
//        [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//            NSLog(@"assetURL = %@, error = %@", assetURL, error);
//            lib = nil;
//        }];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
          
            
            dispatch_async(dispatch_get_main_queue(), ^{
                          [ProgressTool hidden];
                if (success) {
                    [[UIApplication sharedApplication].keyWindow makeToast:@"保存成功" duration:2 position:CSToastPositionCenter];
                }else{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"保存失败" duration:2 position:CSToastPositionCenter];
                }
            });
            
    
            
            NSLog(@"success = %d, error = %@", success, error);
        }];
        
      
    } failure:^(NSError *error) {
        [ProgressTool hidden];
        [[UIApplication sharedApplication].keyWindow makeToast:@"保存失败" duration:2 position:CSToastPositionCenter];
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
