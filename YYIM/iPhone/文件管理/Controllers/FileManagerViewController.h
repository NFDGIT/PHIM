//
//  FileManagerViewController.h
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "BaseViewController.h"

@interface FileManagerViewController : BaseViewController
-(void)show;

@property (nonatomic,strong)NSString * filePath;
@property (nonatomic,strong)void(^selectBlock)(NSURL * url);
@end
