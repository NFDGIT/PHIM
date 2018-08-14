//
//  PHDocumentPickerViewController.h
//  YYIM
//
//  Created by Jobs on 2018/8/6.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHDocumentPickerViewController : UIDocumentPickerViewController
@property (nonatomic,strong)void(^selectBlock)(NSArray * urls);
@end
