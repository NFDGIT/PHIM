//
//  FileManagerViewController.h
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "BaseViewController.h"

@interface FileManager : BaseViewController
-(void)show;

@property (nonatomic,strong)NSString * filePath;
@property (nonatomic,strong)void(^selectBlock)(NSURL * url);
/**
 获取私人资源文件夹
 @return 文件夹路径
 */
+(NSString *)getResourceFolder;
/**
 创建私人资源文件夹
 */
+(void)createResourceFolder;

/**
 存储文件到私人资源文件
 */
+(void)saveImageToResourceFolder:(UIImage *)image;
@end
