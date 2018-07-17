//
//  DBTool.m
//  YYIM
//
//  Created by Jobs on 2018/7/13.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "DBTool.h"
#import <FMDB/FMDB.h>

static DBTool *shared = nil;
@interface DBTool()
@property (nonatomic,strong)FMDatabase * db;
@end
@implementation DBTool
+ (DBTool *)share{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DBTool alloc] init];
        [shared createDB];
    });
    
    return shared;
}

-(void)createDB{
    //1.创建database路径
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"yyim.db"];
    NSLog(@"!!!dbPath = %@",dbPath);
    //2.创建对应路径下数据库
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    _db = db;
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return;
    }
    
    // 创建两个 表 一个表示消息以用户的ID为键值
    
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists chatMessages ('target' TEXT,'sendId' TEXT, 'receivedId' TEXT TEXT,'content'  TEXT,'imageUrl'  TEXT,'msgType' INTEGER NOT NULL)";
    NSString * sql1 = @"create table if not exists chatPersons ('Id' TEXT, 'name' TEXT,'imgUrl'  TEXT)";
  
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [db executeUpdate:sql];
    BOOL result1 = [db executeUpdate:sql1];
    if (result) {
        NSLog(@"create chatMessages success");
    }
    if (result1) {
        NSLog(@"create chatPersons success");
    }
    
    
    [db close];
}

-(void)getMessagesWithTarget:(NSString *)target success:(void (^)(NSArray *))success{
    [_db open];
    NSMutableArray * arr = [NSMutableArray array];
    
    
//    NSString *sql = @"select * from 'chatMessages' where";
    FMResultSet *result = [_db executeQuery:@"select * from 'chatMessages' where target = ?" withArgumentsInArray:@[target]];
    while ([result next]) {
        MsgModel *message = [MsgModel new];
        message.sendId = [result stringForColumn:@"sendId"];
        message.receivedId = [result stringForColumn:@"sendId"];
        message.content = [result stringForColumn:@"content"];
        message.target = [result stringForColumn:@"target"];
        message.msgType = [result intForColumn:@"msgType"];
        message.imageUrl = [result stringForColumn:@"imageUrl"];
       
        [arr addObject:message];
        

        NSLog(@"从数据库查询到的人员 %@",message.receivedId);
     
    }
    if(success)
    {
        success(arr);
    }
    [_db close];
}
-(void)addModel:(MsgModel *)model withTarget:(NSString *)target response:(void (^)(BOOL))response{
    [_db open];
    
    NSString * targets = [NSString stringWithFormat:@"%@",model.target];
    NSString * sendId = [NSString stringWithFormat:@"%@",model.sendId];
    NSString * receivedId = [NSString stringWithFormat:@"%@",model.receivedId];
    NSString * content = [NSString stringWithFormat:@"%@",model.content];
    NSString * imageUrl = [NSString stringWithFormat:@"%@",model.imageUrl];
    NSInteger  msgType = model.msgType;
    
    
    BOOL result = [_db executeUpdate:@"insert into 'chatMessages'(target,sendId,receivedId,content,imageUrl,msgType) values(?,?,?,?,?,?)" withArgumentsInArray:@[targets,sendId,receivedId,content,imageUrl,@(msgType)]];
    if (response) {
        response(result);
    }
    [_db close];
    
    
}


-(void)getChatPersons:(void (^)(NSArray *))success{
    [_db open];
    NSMutableArray * arr = [NSMutableArray array];
    
    
    //    NSString *sql = @"select * from 'chatMessages' where";
    FMResultSet *result = [_db executeQuery:@"select * from 'chatPersons'"];
    while ([result next]) {
        MessageTargetModel *target = [MessageTargetModel new];
        target.Id = [result stringForColumn:@"Id"];
        target.name = [result stringForColumn:@"name"];
        target.imgUrl = [result stringForColumn:@"imgUrl"];
     
        [arr addObject:target];
        NSLog(@"从数据库查询到的人员 %@",target.Id);
        
    }
    if(success)
    {
        success(arr);
    }
    [_db close];
    
}
-(void)deleteTargetModel:(MessageTargetModel *)model response:(void (^)(BOOL))response{
    [_db open];
    
    BOOL result = [_db executeUpdate:@"delete from 'chatPersons' where Id = ?" withArgumentsInArray:@[model.Id]];
    if (response) {
        response(result);
    }
    [_db close];

}

-(void)addTargetModel:(MessageTargetModel *)model response:(void (^)(BOOL))response{
    [self deleteTargetModel:model response:^(BOOL res) {
    }]; // 为防止重复先删除
    
    
    
    
    
    [_db open];
    
    NSString * Id = [NSString stringWithFormat:@"%@",model.Id];
    NSString * name = [NSString stringWithFormat:@"%@",model.name];
    NSString * imgUrl = [NSString stringWithFormat:@"%@",model.imgUrl];

    BOOL result = [_db executeUpdate:@"insert into 'chatPersons' (Id,name,imgUrl) values(?,?,?)" withArgumentsInArray:@[Id,name,imgUrl]];
    if (response) {
        response(result);
    }
    [_db close];
    
}
@end
