//
//  ProgressTool.h
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressTool : NSObject
+ (instancetype)share;
+(void)show;
+(void)showWithText:(NSString *)text;
+(void)showProgressWithText:(NSString *)text;
+(void)setText:(NSString *)text;
+(void)setProgress:(float )progress;
+(void)hidden;
+(void)showNetError;
@end
