//
//  FileManagerCollectionViewCell.h
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileManagerModel.h"

@interface FileManagerCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)FileManagerModel * model;
@property (nonatomic,strong)void(^itemClick)(NSIndexPath * indexPath);
@end
