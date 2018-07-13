//
//  ProgressTool.m
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "ProgressTool.h"
#import <MBProgressHUD/MBProgressHUD.h>


@implementation ProgressTool
+(void)show{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}
+(void)hidden{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
+(void)showNetError{

    
}
@end
