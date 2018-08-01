//
//  ProgressTool.m
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ProgressTool.h"
#import <MBProgressHUD/MBProgressHUD.h>
static ProgressTool *shared = nil;

@interface ProgressTool()
@property (nonatomic,strong)MBProgressHUD * hub;
@end
@implementation ProgressTool
+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[ProgressTool alloc] init];
   
    });
    return shared;
}

+(void)show{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}
+(void)hidden{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [[ProgressTool share].hub hideAnimated:YES];
}

+(void)showWithText:(NSString *)text{
//    //圆形进度条
    
    [ProgressTool share].hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [ProgressTool share].hub.label.text = text;
    [ProgressTool share].hub.margin = 10.f;
    [[ProgressTool share].hub showAnimated:YES];
 
}
+(void)showProgressWithText:(NSString *)text{
    
    [ProgressTool share].hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [ProgressTool share].hub.mode = MBProgressHUDModeDeterminate;
    [ProgressTool share].hub.customView = [[MBBarProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [ProgressTool share].hub.label.text = text;
    [ProgressTool share].hub.margin = 10.f;
    [[ProgressTool share].hub showAnimated:YES];
}
+(void)setText:(NSString *)text{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressTool share].hub.label.text = text;
//    });
 
}
+(void)setProgress:(float )progress{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressTool share].hub.progress = progress;
//    });


    
//    if ([[ProgressTool share].hub.customView isKindOfClass:[MBRoundProgressView class]]) {
//
//
//        [((MBRoundProgressView *)([[[ProgressTool share]hub]customView])) setProgress:progress];
//
//    }
//    if ([[ProgressTool share].hub.customView isKindOfClass:[ class]]) {
//        (( *)([[[ProgressTool share]hub]customView])).progress = progress;
//
//
//    }

}

+(void)showNetError{

}
@end
