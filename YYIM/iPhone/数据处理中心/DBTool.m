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
@property (nonatomic,strong)FMDatabase * accountDb;

@end
@implementation DBTool
+ (DBTool *)share{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DBTool alloc] init];
        [shared createDB];
        [shared createAccountDb];

    });
    
    return shared;
}

#pragma mark -- 私人数据库
-(void)createAccountDb{
    
    [self createAccountFolderWithAccount:CurrentUserId];
    
    //1.创建database路径
    NSString *filePath = [self getAccountFilePathWithAccount:CurrentUserId];

    NSString *dbPath = [filePath stringByAppendingPathComponent:@"account.db"];
    NSLog(@"!!!dbPath = %@",dbPath);
    //2.创建对应路径下数据库
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    _accountDb = db;
    
    
    
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return;
    }
    
    // 创建两个 表 一个表示消息以用户的ID为键值
    
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists chatMessages ('target' TEXT,'headIcon' TEXT,'sendId' TEXT, 'receivedId' TEXT TEXT,'content'  TEXT,'imageUrl'  TEXT,'msgType' INTEGER NOT NULL,'GroupMsg'  INTEGER,'MsgInfoClass' INTEGER)";// 聊天的 表
    
    NSString * sql1 = @"create table if not exists conversations ('Id' TEXT, 'name' TEXT,'imgUrl'  TEXT,'GroupMsg'  INTEGER,'newCount' INTEGER)"; // 会话的表
    
    NSString * sql2 = @"create table if not exists userList ('userID' TEXT, 'userName' TEXT,'UnderWrite'  TEXT,'HeadName'  TEXT,'UserStatus'  TEXT,'State' TEXT,'Email' TEXT,'Sex' TEXT,'RealName' TEXT,'Phone' TEXT)"; // 用户详情的表

    
    

    
    
    
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



/**
  获取私人文件夹

 @param account 私人账号
 @return 文件夹路径
 */
-(NSString *)getAccountFilePathWithAccount:(NSString *)account{
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString * accountsFilePath = [docsdir stringByAppendingPathComponent:@"Accounts"];//将需要创建的串拼接到后面
    NSString * accountFilePath = [accountsFilePath stringByAppendingPathComponent:account];
    return accountFilePath;
}


/**
 创建私人文件夹

 @param account 账号
 */
-(void)createAccountFolderWithAccount:(NSString *)account{
    //获取Document文件
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    NSString * accountsFilePath = [docsdir stringByAppendingPathComponent:@"Accounts"];//将需要创建的串拼接到后面
    BOOL accountsIsDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL accountsExisted = [fileManager fileExistsAtPath:accountsFilePath isDirectory:&accountsIsDir];
    if ( !(accountsIsDir == YES && accountsExisted == YES) ) {//如果
        [fileManager createDirectoryAtPath:accountsFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSString * accountFilePath = [accountsFilePath stringByAppendingPathComponent:account];
    BOOL accountIsDir = NO;
    BOOL accountExisted = [fileManager fileExistsAtPath:accountFilePath isDirectory:&accountIsDir];
    if (!(accountIsDir == YES && accountExisted == YES) ) {
        [fileManager createDirectoryAtPath:accountFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}


#pragma mark -- 公共数据库


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
    
    NSString * sql1 = @"create table if not exists conversations ('Id' TEXT, 'name' TEXT,'imgUrl'  TEXT,'GroupMsg'  INTEGER,'newCount' INTEGER)"; // 会话的表
    
    NSString * sql2 = @"create table if not exists userList ('userID' TEXT, 'userName' TEXT,'UnderWrite'  TEXT,'HeadName'  TEXT,'UserStatus'  TEXT,'State' TEXT,'Email' TEXT,'Sex' TEXT,'RealName' TEXT,'Phone' TEXT)"; // 用户详情的表
    
    NSString * sql3 = @"create table if not exists groupList ('groupDep' TEXT, 'groupID' TEXT,'groupName'  TEXT,'memberList'  TEXT)"; // 全部群组的表

    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [db executeUpdate:sql];
    BOOL result1 = [db executeUpdate:sql1];
    BOOL result2 = [db executeUpdate:sql2];
    BOOL result3 = [db executeUpdate:sql3];
    if (result) {
        NSLog(@"create chatMessages success");
    }
    if (result1) {
        NSLog(@"create conversations success");
    }
    if (result2) {
        NSLog(@"create userList success");
    }
    if (result3) {
        NSLog(@"create groupList success");
    }
    
    
    [db close];
}

#pragma mark -- 聊天记录
/**
 添加聊天记录
 
 @param model 聊天记录的model
 @param target  会话的ID
 @param response 添加的结果
 */
-(void)addModel:(MsgModel *)model withTarget:(NSString *)target response:(void (^)(BOOL))response{
    [_accountDb open];
    
    NSString * targets = [NSString stringWithFormat:@"%@",model.target];
    NSString * headIcon = [NSString stringWithFormat:@"%@",model.headIcon];
    NSString * sendId = [NSString stringWithFormat:@"%@",model.sendId];
    NSString * receivedId = [NSString stringWithFormat:@"%@",model.receivedId];
    NSString * content = [NSString stringWithFormat:@"%@",model.content];
    NSString * imageUrl = [NSString stringWithFormat:@"%@",model.imageUrl];
    BOOL GroupMsg      = model.GroupMsg;
    InformationType  MsgInfoClass = model.MsgInfoClass;
    
    NSInteger  msgType = model.msgType;
    
    
    BOOL result = [_accountDb executeUpdate:@"insert into 'chatMessages'(target,headIcon,sendId,receivedId,content,imageUrl,msgType,GroupMsg,MsgInfoClass) values(?,?,?,?,?,?,?,?,?)" withArgumentsInArray:@[targets,headIcon,sendId,receivedId,content,imageUrl,@(msgType),@(GroupMsg),@(MsgInfoClass)]];
    if (response) {
        response(result);
    }
    [_accountDb close];
    
    
}
/**
 删除 某个会话的聊天记录
 
 @param conversationId 会话ID
 @param response response description
 */
-(void)deleteMessagesWithConversationId:(NSString *)conversationId response:(void(^)(BOOL success))response{
    [_accountDb open];
    
    BOOL result = [_accountDb executeUpdate:@"delete from 'chatMessages' where target = ?" withArgumentsInArray:@[conversationId]];
    if (response) {
        response(result);
    }
    [_accountDb close];
}

/**
 获取聊天记录

 @param target 会话的ID
 @param success 是否成功
 @return ‘’‘
 */
-(NSArray *)getMessagesWithTarget:(NSString *)target success:(void (^)(NSArray *))success{
    [_accountDb open];
    NSMutableArray * arr = [NSMutableArray array];
    
    
//    NSString *sql = @"select * from 'chatMessages' where";

    FMResultSet *result = [_accountDb executeQuery:@"select * from 'chatMessages' where target = ?" withArgumentsInArray:@[target]];
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
    [_accountDb close];
    return arr;
}


#pragma mark -- 会话
/**
 添加会画
 
 @param model 会话的模型
 @param response 添加会话的结果
 */
-(void)addConversationModel:(ConversationModel *)model response:(void (^)(BOOL))response{
    [self deleteConversationId:model.Id response:^(BOOL res) {
    }]; // 为防止重复先删除
    
    [_accountDb open];
    
    NSString * Id = [NSString stringWithFormat:@"%@",model.Id];
    NSString * name = [NSString stringWithFormat:@"%@",model.name];
    NSString * imgUrl = [NSString stringWithFormat:@"%@",model.imgUrl];
    NSInteger GroupMsg = model.GroupMsg;
    NSUInteger newCount = model.newCount;
    
    BOOL result = [_accountDb executeUpdate:@"insert into 'conversations' (Id,name,imgUrl,GroupMsg,newCount) values(?,?,?,?,?)" withArgumentsInArray:@[Id,name,imgUrl,@(GroupMsg),@(newCount)]];
    if (response) {
        response(result);
    }
    [_accountDb close];
    
}
/**
 删除某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)deleteConversationId:(NSString *)conversationId response:(void (^)(BOOL))response{
    [_accountDb open];
    
    BOOL result = [_accountDb executeUpdate:@"delete from 'conversations' where Id = ?" withArgumentsInArray:@[conversationId]];
    if (response) {
        response(result);
    }
    [_accountDb close];
}
/**
 更新会话 不改变顺序
 
 @param conversationModel 新消息个数
 @param response 结果
 */
-(void)updateConversationWith:(ConversationModel *)conversationModel response:(void(^)(BOOL success))response{
    
    [_accountDb open];
    //0.直接sql语句
    //    BOOL result = [db executeUpdate:@"update 't_student' set ID = 110 where name = 'x1'"];
    //1.
    //    BOOL result = [db executeUpdate:@"update 't_student' set ID = ? where name = ?",@111,@"x2" ];
    //2.
    //    BOOL result = [db executeUpdateWithFormat:@"update 't_student' set ID = %d where name = %@",113,@"x3" ];
    //3.
    
    NSString * Id = [NSString stringWithFormat:@"%@",conversationModel.Id];
    NSString * name = [NSString stringWithFormat:@"%@",conversationModel.name];
    NSString * imgUrl = [NSString stringWithFormat:@"%@",conversationModel.imgUrl];
    NSInteger GroupMsg = conversationModel.GroupMsg;
    NSUInteger newCount = conversationModel.newCount;
    
    BOOL result = [_accountDb executeUpdate:@"update 'conversations' set name = ?, imgUrl = ?, GroupMsg = ?, newCount = ? where Id = ?" withArgumentsInArray:@[name,imgUrl,@(GroupMsg),@(newCount),Id]];
    
    if (response) {
        response(result);
    }
    if (result) {
        NSLog(@"update 't_student' success");
    } else {
    }
    [_accountDb close];
}

/**
 获取所有的会话
 
 @param success 获取成功
 */
-(void)getConversations:(void (^)(NSArray *))success{
    [_accountDb open];
    NSMutableArray * arr = [NSMutableArray array];
    
    
    //    NSString *sql = @"select * from 'chatMessages' where";
    FMResultSet *result = [_accountDb executeQuery:@"select * from 'conversations'"];
    while ([result next]) {
        ConversationModel *conversationModel = [ConversationModel new];
        conversationModel.Id = [result stringForColumn:@"Id"];
        conversationModel.name = [result stringForColumn:@"name"];
        conversationModel.imgUrl = [result stringForColumn:@"imgUrl"];
        conversationModel.GroupMsg = [result boolForColumn:@"GroupMsg"];
        conversationModel.newCount  = [result intForColumn:@"newCount"];
        [arr addObject:conversationModel];
//        NSLog(@"从数据库查询到的人员 %@",target.Id);
        
    }
    if(success)
    {
        success(arr);
    }
    [_accountDb close];
    
}



/**
 获取某个会话
 
 @param conversationId 会话Id
 @param response 结果
 */
-(void)getConversationWithId:(NSString *)conversationId response:(void (^)(ConversationModel * model))response{
    [_accountDb open];
    NSMutableArray * arr = [NSMutableArray array];
    
    
    //    NSString *sql = @"select * from 'chatMessages' where";
    FMResultSet *result = [_accountDb executeQuery:@"select * from 'conversations' where Id = ?" withArgumentsInArray:@[conversationId]];
    while ([result next]) {
        ConversationModel *conversationModel = [ConversationModel new];
        conversationModel.Id = [result stringForColumn:@"Id"];
        conversationModel.name = [result stringForColumn:@"name"];
        conversationModel.imgUrl = [result stringForColumn:@"imgUrl"];
        conversationModel.GroupMsg = [result boolForColumn:@"GroupMsg"];
        conversationModel.newCount = [result intForColumn:@"newCount"];
        
        [arr addObject:conversationModel];
        //        NSLog(@"从数据库查询到的人员 %@",target.Id);
        
    }

    if(response)
    {
        if (arr.count <= 0) {
            response(nil);
        }else{
            response(arr.firstObject);
        }
    }
    [_accountDb close];
    
}
#pragma mark -- 用户信息

/**
 添加用户信息
 
 @param model 用户信息model
 @param response 添加用户信息的结果
 */
-(void)addUserModel:(UserInfoModel *)model response:(void (^)(BOOL))response{
    [_db open];
    
    NSString *userID = [NSString stringWithFormat:@"%@",model.userID];
    NSString *userName = [NSString stringWithFormat:@"%@",model.userName];
    NSString *UnderWrite = [NSString stringWithFormat:@"%@",model.UnderWrite];
    NSString *HeadName = [NSString stringWithFormat:@"%@",model.HeadName];
    NSString *UserStatus = [NSString stringWithFormat:@"%@",model.UserStatus];
    
    NSString *Phone = [NSString stringWithFormat:@"%@",model.Phone];
    NSString *State = [NSString stringWithFormat:@"%@",model.State];
    NSString *Email = [NSString stringWithFormat:@"%@",model.Email];
    NSString *Sex = [NSString stringWithFormat:@"%@",model.Sex];
    NSString *RealName = [NSString stringWithFormat:@"%@",model.RealName];
    
    
//    'State' TEXT,'Email' TEXT,'Sex' TEXT,'RealName' TEXT
    BOOL result = [_db executeUpdate:@"insert into 'userList' (userID,userName,UnderWrite,HeadName,UserStatus,State,Email,Sex,RealName,Phone) values(?,?,?,?,?,?,?,?,?,?)" withArgumentsInArray:@[userID,userName,UnderWrite,HeadName,UserStatus,State,Email,Sex,RealName,Phone]];
    if (response) {
        response(result);
    }
    [_db close];
    
}
/**
 更新用户信息
 
 @param model 用户信息model
 @param response 添加用户信息的结果
 */
-(void)updateUserModel:(UserInfoModel *)model response:(void (^)(BOOL))response{
    [_db open];
    
    NSString *userID = [NSString stringWithFormat:@"%@",model.userID];
    NSString *userName = [NSString stringWithFormat:@"%@",model.userName];
    NSString *UnderWrite = [NSString stringWithFormat:@"%@",model.UnderWrite];
    NSString *HeadName = [NSString stringWithFormat:@"%@",model.HeadName];
    NSString *UserStatus = [NSString stringWithFormat:@"%@",model.UserStatus];
    
    NSString *Phone = [NSString stringWithFormat:@"%@",model.Phone];
    NSString *State = [NSString stringWithFormat:@"%@",model.State];
    NSString *Email = [NSString stringWithFormat:@"%@",model.Email];
    NSString *Sex = [NSString stringWithFormat:@"%@",model.Sex];
    NSString *RealName = [NSString stringWithFormat:@"%@",model.RealName];
    
//        BOOL result = [_accountDb executeUpdate:@"update 'conversations' set name = ?, imgUrl = ?, GroupMsg = ?, newCount = ? where Id = ?" withArgumentsInArray:@[name,imgUrl,@(GroupMsg),@(newCount),Id]];
    
    
    //    'State' TEXT,'Email' TEXT,'Sex' TEXT,'RealName' TEXT
    
//    userID
    BOOL result = [_db executeUpdate:@"update  'userList' set userName = ?, UnderWrite = ?,HeadName = ?,UserStatus= ?,State = ? ,Email= ?,Sex = ?,RealName = ?,Phone = ? where userID = ?" withArgumentsInArray:@[userName,UnderWrite,HeadName,UserStatus,State,Email,Sex,RealName,Phone,userID]];
    if (response) {
        response(result);
    }
    
    [_db close];
    
}
/**
 获取所有的用户信息
 
 @param success 获取成功
 */
-(void)getUserModels:(void (^)(NSDictionary *))success{
    [_db open];
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    
    //    NSString *sql = @"select * from 'chatMessages' where";
    FMResultSet *result = [_db executeQuery:@"select * from 'userList'"];
    while ([result next]) {
        UserInfoModel * userInfoModel = [UserInfoModel new];
        userInfoModel.userID = [result stringForColumn:@"userID"];
        userInfoModel.userName = [result stringForColumn:@"userName"];
        userInfoModel.UnderWrite = [result stringForColumn:@"UnderWrite"];
        userInfoModel.HeadName = [result stringForColumn:@"HeadName"];
        userInfoModel.UserStatus = [result stringForColumn:@"UserStatus"];
        
        userInfoModel.RealName = [result stringForColumn:@"RealName"];
        userInfoModel.Phone = [result stringForColumn:@"Phone"];
        userInfoModel.Email = [result stringForColumn:@"Email"];
        userInfoModel.Sex = [result stringForColumn:@"Sex"];
        userInfoModel.State = [result stringForColumn:@"State"];
        
        [mdic addEntriesFromDictionary:@{userInfoModel.userID:userInfoModel}];
        //        NSLog(@"从数据库查询到的人员 %@",target.Id);
    }
    if(success)
    {
        success(mdic);
    }
    [_db close];
}
/**
 根据 userid 获取 model
 
 @param userId 用户id
 @param model 用户的model
 */
-(void)getUserModelWithUserId:(NSString *)userId response:(UserInfoModel *)model{
    
    
}
#pragma mark -- 群组信息
/**
 添加群信息
 
 @param model 群model
 @param response 添加群组信息的结果
 */
-(void)addGroupModel:(GroupChatModel *)model response:(void (^)(BOOL))response{
    [_db open];
    
    NSString *groupDep = [NSString stringWithFormat:@"%@",model.groupDep];
    NSString *groupID = [NSString stringWithFormat:@"%@",model.groupID];
    NSString *groupName = [NSString stringWithFormat:@"%@",model.groupName];
    NSString *memberList = [NSString stringWithFormat:@"%@",model.memberList];
  
    
    //    'State' TEXT,'Email' TEXT,'Sex' TEXT,'RealName' TEXT
    BOOL result = [_db executeUpdate:@"insert into 'groupList' (groupDep,groupID,groupName,memberList) values(?,?,?,?)" withArgumentsInArray:@[groupDep,groupID,groupName,memberList]];
    if (response) {
        response(result);
    }
    [_db close];
}
/**
 更新群信息
 
 @param model 群model
 @param response 更新群组信息的结果
 */
-(void)updateGroupModel:(GroupChatModel *)model response:(void (^)(BOOL))response{
    
    
}
/**
 根据 groupid 获取 model
 
 @param groupid 用户id
 @param response 结果
 */
-(void)getGroupModelWithGroupid:(NSString *)groupid response:(void (^)(GroupChatModel * model))response{
    
    
    
}


@end
