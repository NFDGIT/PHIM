//
//  FileManagerModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/30.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerModel : NSObject
@property (nonatomic,strong)NSString * filePath;
@property (nonatomic,strong)NSString * fileName;
@property (nonatomic,strong)NSDictionary * fileAttributes;
@end
