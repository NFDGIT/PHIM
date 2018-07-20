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
    NSString *sql = @"create table if not exists chatMessages ('target' TEXT,'headIcon' TEXT,'sendId' TEXT, 'receivedId' TEXT TEXT,'content'  TEXT,'imageUrl'  TEXT,'msgType' INTEGER NOT NULL,'GroupMsg'  INTEGER,'MsgInfoClass' INTEGER)";// 聊天的 表
    
    NSString * sql1 = @"create table if not exists conversations ('Id' TEXT, 'name' TEXT,'imgUrl'  TEXT,'GroupMsg'  INTEGER)"; // 会话的表
    
    NSString * sql2 = @"create table if not exists userList ('AssemblyVersion' TEXT, 'ClientType' TEXT,'Dep'  TEXT,'DepInfo'  TEXT,'Email'  TEXT,'FilePort'  TEXT,'HeadName'  TEXT,'HeartBeatTime'  TEXT,'IP'  TEXT,'NewNode'  TEXT,'Phone'  TEXT,'PhotoContent'  TEXT,'PhotoName'  TEXT,'Port'  TEXT,'RealName'  TEXT,'Sex'  TEXT,'State'  TEXT,'StateInfo'  TEXT,'UnderWrite'  TEXT,'UserId'  TEXT,'UserStatus'  TEXT,'assemblyVersion'  TEXT,'headName'  TEXT)"; // 用户详情的表
    
//    @property (nonatomic,strong)NSString *AssemblyVersion;
//    @property (nonatomic,strong)NSString *ClientType;
//    @property (nonatomic,strong)NSString *Dep;
//    @property (nonatomic,strong)NSString *DepInfo;
//    @property (nonatomic,strong)NSString *Email;
//    @property (nonatomic,strong)NSString *FilePort;
//    @property (nonatomic,strong)NSString *HeadName;
//    @property (nonatomic,strong)NSString *HeartBeatTime;
//    @property (nonatomic,strong)NSString *IP;
//    @property (nonatomic,strong)NSString *NewNode;
//    @property (nonatomic,strong)NSString *Phone;
//    @property (nonatomic,strong)NSString *PhotoContent;
//    @property (nonatomic,strong)NSString *PhotoName;
//    @property (nonatomic,strong)NSString *Port;
//    @property (nonatomic,strong)NSString *RealName;
//    @property (nonatomic,strong)NSString *Sex;
//    @property (nonatomic,strong)NSString *State;
//    @property (nonatomic,strong)NSString *StateInfo;
//    @property (nonatomic,strong)NSString *UnderWrite;
//    @property (nonatomic,strong)NSString *UserId;
//    @property (nonatomic,strong)NSString *UserStatus;
//    @property (nonatomic,strong)NSString *assemblyVersion;
//    @property (nonatomic,strong)NSString *headName;
    
  
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [db executeUpdate:sql];
    BOOL result1 = [db executeUpdate:sql1];
    BOOL result2 = [db executeUpdate:sql2];
    if (result) {
        NSLog(@"create chatMessages success");
    }
    if (result1) {
        NSLog(@"create conversations success");
    }
    if (result2) {
        NSLog(@"create userList success");
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
        message.headIcon = [result stringForColumn:@"headIcon"];
        message.sendId = [result stringForColumn:@"sendId"];
        message.receivedId = [result stringForColumn:@"sendId"];
        message.content = [result stringForColumn:@"content"];
        message.target = [result stringForColumn:@"target"];
        message.msgType = [result intForColumn:@"msgType"];
        message.imageUrl = [result stringForColumn:@"imageUrl"];
        message.MsgInfoClass = [result intForColumn:@"MsgInfoClass"];
        message.GroupMsg     = [result intForColumn:@"GroupMsg"];
        
       
        [arr addObject:message];
        

//        NSLog(@"从数据库查询到的人员 %@",message.receivedId);
     
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
    NSString * headIcon = [NSString stringWithFormat:@"%@",model.headIcon];
    NSString * sendId = [NSString stringWithFormat:@"%@",model.sendId];
    NSString * receivedId = [NSString stringWithFormat:@"%@",model.receivedId];
    NSString * content = [NSString stringWithFormat:@"%@",model.content];
    NSString * imageUrl = [NSString stringWithFormat:@"%@",model.imageUrl];
    BOOL GroupMsg      = model.GroupMsg;
    InformationType  MsgInfoClass = model.MsgInfoClass;

    NSInteger  msgType = model.msgType;
    
    
    BOOL result = [_db executeUpdate:@"insert into 'chatMessages'(target,headIcon,sendId,receivedId,content,imageUrl,msgType,GroupMsg,MsgInfoClass) values(?,?,?,?,?,?,?,?,?)" withArgumentsInArray:@[targets,headIcon,sendId,receivedId,content,imageUrl,@(msgType),@(GroupMsg),@(MsgInfoClass)]];
    if (response) {
        response(result);
    }
    [_db close];
    
    
}
#pragma mark -- 会话的操作
/**
 获取所有的会话
 
 @param success 获取成功
 */
-(void)getConversations:(void (^)(NSArray *))success{
    [_db open];
    NSMutableArray * arr = [NSMutableArray array];
    
    
    //    NSString *sql = @"select * from 'chatMessages' where";
    FMResultSet *result = [_db executeQuery:@"select * from 'conversations'"];
    while ([result next]) {
        ConversationModel *conversationModel = [ConversationModel new];
        conversationModel.Id = [result stringForColumn:@"Id"];
        conversationModel.name = [result stringForColumn:@"name"];
        conversationModel.imgUrl = [result stringForColumn:@"imgUrl"];
        conversationModel.GroupMsg = [result boolForColumn:@"GroupMsg"];
     
        [arr addObject:conversationModel];
//        NSLog(@"从数据库查询到的人员 %@",target.Id);
        
    }
    if(success)
    {
        success(arr);
    }
    [_db close];
    
}
/**
 删除某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)deleteConversationId:(NSString *)conversationId response:(void (^)(BOOL))response{
    [_db open];
    
    BOOL result = [_db executeUpdate:@"delete from 'conversations' where Id = ?" withArgumentsInArray:@[conversationId]];
    if (response) {
        response(result);
    }
    [_db close];
}
/**
 添加会画
 
 @param model 会话的模型
 @param response 添加会话的结果
 */
-(void)addConversationModel:(ConversationModel *)model response:(void (^)(BOOL))response{
    [self deleteConversationId:model.Id response:^(BOOL res) {
    }]; // 为防止重复先删除
    
    
    
    
    [_db open];
    
    NSString * Id = [NSString stringWithFormat:@"%@",model.Id];
    NSString * name = [NSString stringWithFormat:@"%@",model.name];
    NSString * imgUrl = [NSString stringWithFormat:@"%@",model.imgUrl];
    NSInteger GroupMsg = model.GroupMsg;

    BOOL result = [_db executeUpdate:@"insert into 'conversations' (Id,name,imgUrl,GroupMsg) values(?,?,?,?)" withArgumentsInArray:@[Id,name,imgUrl,@(GroupMsg)]];
    if (response) {
        response(result);
    }
    [_db close];
    
}
#pragma mark -- 会话

/**
 添加用户信息
 
 @param model 用户信息model
 @param response 添加用户信息的结果
 */
-(void)addUserModel:(UserInfoModel *)model response:(void (^)(BOOL))response{
    [_db open];
    
    
    
////@"create table if not exists userList ('AssemblyVersion' TEXT, 'ClientType' TEXT,'Dep'  TEXT,'DepInfo'  TEXT,'Email'  TEXT,'FilePort'  TEXT,'HeadName'  TEXT,'HeartBeatTime'  TEXT,'IP'  TEXT,'NewNode'  TEXT,'Phone'  TEXT,'PhotoContent'  TEXT,'PhotoName'  TEXT,'Port'  TEXT,'RealName'  TEXT,'Sex'  TEXT,'State'  TEXT,'StateInfo'  TEXT,'UnderWrite'  TEXT,'UserId'  TEXT,'UserStatus'  TEXT,'assemblyVersion'  TEXT,'headName'  TEXT,)"
//
//
//NSString *AssemblyVersion = [NSString stringWithFormat:@"%@",model.assemblyVersion];
//NSString *ClientType = [NSString stringWithFormat:@"%@",model.ClientType];
//NSString *Dep = [NSString stringWithFormat:@"%@",model.Dep];
//NSString *DepInfo = [NSString stringWithFormat:@"%@",model.DepInfo];
//NSString *Email = [NSString stringWithFormat:@"%@",model.Email];
//NSString *FilePort = [NSString stringWithFormat:@"%@",model.FilePort];
//NSString *HeadName = [NSString stringWithFormat:@"%@",model.headName];
//NSString *HeartBeatTime = [NSString stringWithFormat:@"%@",model.HeartBeatTime];
//NSString *IP = [NSString stringWithFormat:@"%@",model.IP];
//NSString *NewNode = [NSString stringWithFormat:@"%@",model.NewNode];
//NSString *Phone = [NSString stringWithFormat:@"%@",model.Phone];
//NSString *PhotoContent = [NSString stringWithFormat:@"%@",model.PhotoContent];
//NSString *PhotoName = [NSString stringWithFormat:@"%@",model.PhotoName];
//NSString *Port = [NSString stringWithFormat:@"%@",model.Port];
//NSString *RealName = [NSString stringWithFormat:@"%@",model.RealName];
//NSString *Sex = [NSString stringWithFormat:@"%@",model.Sex];
//NSString *State = [NSString stringWithFormat:@"%@",model.State];
//NSString *StateInfo = [NSString stringWithFormat:@"%@",model.StateInfo];
//NSString *UnderWrite = [NSString stringWithFormat:@"%@",model.UnderWrite];
//NSString *UserId = [NSString stringWithFormat:@"%@",model.UserId];
//NSString *UserStatus = [NSString stringWithFormat:@"%@",model.UserStatus];
//NSString *assemblyVersion = [NSString stringWithFormat:@"%@",model.assemblyVersion];
//NSString *headName = [NSString stringWithFormat:@"%@",model.headName];
//
//    BOOL result = [_db executeUpdate:@"insert into 'conversations' (AssemblyVersion,ClientType,Dep,DepInfo,'Email'  TEXT,'FilePort'  TEXT,'HeadName'  TEXT,'HeartBeatTime'  TEXT,'IP'  TEXT,'NewNode'  TEXT,'Phone'  TEXT,'PhotoContent'  TEXT,'PhotoName'  TEXT,'Port'  TEXT,'RealName'  TEXT,'Sex'  TEXT,'State'  TEXT,'StateInfo'  TEXT,'UnderWrite'  TEXT,'UserId'  TEXT,'UserStatus'  TEXT,'assemblyVersion'  TEXT,'headName'  TEXT) values(?,?,?,?)" withArgumentsInArray:@[Id,name,imgUrl,@(GroupMsg)]];
//    if (response) {
//        response(result);
//    }
    [_db close];
    
}
/**
 获取所有的用户信息
 
 @param success 获取成功
 */
-(void)getUserModels:(void (^)(NSArray *))success{
    
}

@end
