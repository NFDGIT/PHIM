//
//  ContactsListModel.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsListModel : NSObject
@property (nonatomic,strong)NSString * Text;
@property (nonatomic,strong)NSString * ImageIndex;
@property (nonatomic,strong)NSString * SelectedImageIndex;
@property (nonatomic,strong)NSString * Checked;
@property (nonatomic,assign)BOOL Expanded;
@property (nonatomic,strong)NSString * Tag;

@property (nonatomic,strong)NSArray<ContactsListModel *> * Nodes;


@property (nonatomic,strong)NSArray * level;

//-(NSMutableArray *)getModelsWithDatas:(NSArray *)datas;
@end
