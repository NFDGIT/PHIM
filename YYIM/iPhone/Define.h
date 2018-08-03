

// 测试服务器
//#define serverHost  @"http://10.120.35.64:5533/"
//#define serverUploadFileHost @"http://10.120.35.64:8620/"

//#define serverHost   @"10.120.35.64"
//#define serverPort   5533
//#define serverSocketPort   5540
//#define serverUploadFilePort 8620
//#define serverAddress @"http://10.120.35.64:5533/"
//#define serverUploadFileAddress @"http://10.120.35.64:8620/"
//#define UrlPath   [NSString stringWithFormat:@"%@%@",serverAddress,@"RemotingService"]



#define serverHost   @"172.16.133.24"
#define serverPort   5533
#define serverSocketPort   5540
#define serverUploadFilePort 8620z
#define serverAddress @"http://172.16.133.24:5533/"
#define serverUploadFileAddress @"http://172.16.133.24:8620/"
#define UrlPath   [NSString stringWithFormat:@"%@%@",serverAddress,@"RemotingService"]





#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))


#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NaviHeight   (49 + StatusBarHeight)




#define SizeScale (SCREEN_WIDTH != 414 ?1 :1.2)
#define Scale(size)  size * 1

#define ContentHeight ScreenHeight - NaviHeight
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define FontNormal  [UIFont systemFontOfSize:14]
#define FontBig  [UIFont systemFontOfSize:16]
#define FontSmall  [UIFont systemFontOfSize:12]


#pragma mark -- 颜色

#define ColorBack   [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]
#define ColorWhite  [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define ColorGray   [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7]
#define ColorBlack  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
#define ColorRed    [UIColor colorWithRed:235/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define ColorTheme  [UIColor colorWithRed:25/255.0 green:147/255.0 blue:251/255.0 alpha:1]


#define NotiForReceive @"NotiForReceive"



#pragma mark -- 用户的信息
/**
 用户id
 */
#define CurrentUserId             [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserId"]]
#define setCurrentUserId(currentUserId)  [[NSUserDefaults standardUserDefaults] setValue:currentUserId forKey:@"CurrentUserId"]


/**
用户 头像
 */
#define CurrentUserIcon             [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserIcon"]]
#define setCurrentUserIcon(currentUserIcon)  [[NSUserDefaults standardUserDefaults] setValue:currentUserIcon forKey:@"CurrentUserIcon"]
/**
 用户 名字
 */
#define CurrentUserName             [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserName"]]
#define setCurrentUserName(currentUserName)  [[NSUserDefaults standardUserDefaults] setValue:currentUserName forKey:@"CurrentUserName"]

/**
 用户 签名
 */
#define CurrentUserUnderWrite             [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserUnderWrite"]]
#define setCurrentUserUnderWrite(currentUserUnderWrite)  [[NSUserDefaults standardUserDefaults] setValue:currentUserUnderWrite forKey:@"CurrentUserUnderWrite"]

/**
 用户 状态
 */

#define CurrentUserStatus             [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentUserStatus"]
#define setCurrentUserStatus(currentUserStatus)  [[NSUserDefaults standardUserDefaults] setInteger:currentUserStatus forKey:@"CurrentUserStatus"];

/**
 * 服务器是否能联通
 */
#define    serverOnLine [[NSUserDefaults standardUserDefaults] boolForKey:@"ServerIsOnline"]
#define    setServerOnLine(onLine) [[NSUserDefaults standardUserDefaults] setBool:onLine forKey:@"ServerIsOnline"]


#pragma mark -- 消息类型 枚举
typedef NS_ENUM(NSUInteger,InformationType) {
    InformationTypeSingOut = 0,            // 用户离线
    InformationTypeSuccessLogin = 1,       // 服务器告诉自己已经登录,登录过程
    InformationTypeUpdateSelfState = 2,    // 更新当前用户在线状态
    InformationTypeNewUserLogin = 3,       // 服务器告诉用户有新的联系人登录
    InformationTypeUsersDataArrival = 4,   // 收到用户部分联系人的资料
    InformationTypeUserChatArrival = 5,    // 收到用户联系人发送来的对话消息
    InformationTypeReturnChatArrival = 6,  // 联系人不在线
    InformationTypeNoticeArrival = 7,      // 收到联系人发送来的群发通知消
    InformationTypeBroadcastChatPic = 8,   // 群自定义图片
    InformationTypeChatPic = 9,            // 消息自定义图片
    
    InformationTypeSendFileRequest = 10,   // 收到联系人发出发送文件请求
    InformationTypeSendPicRequest = 11,    // 收到联系人发出发送自定义图片请求
    InformationTypeChat = 12,              // 聊天信息 12
    InformationTypeVibration = 13,              // 窗口抖动
    InformationTypeGetOfflineMessage = 14,              // 请求离线消息
    InformationTypeOfflineMessage = 15,              // 服务端转发离线消息给客户端
    InformationTypeUpdate = 16,              // 服务器通知升级到最新版本
    
    InformationTypeUpdateHead = 20,              // 服务器更新头像
    InformationTypeUpdateFriendHead = 21,              // 服务器更新好友头像
    InformationTypeUpdateMySelfMsg = 22,              // 更新自己基本信息
    InformationTypeUpdateFriendMsg = 23,              // 更新好友基本信息
    InformationTypeLeaveOut = 24,              // 强制下线
    
    InformationTypeGetUserInfo = 32,              // 获取用户资料（C->S）
    InformationTypeGetSomeUsers = 34,              // 获取指定某些用户的资料（C->S）
    InformationTypeBroadcastChat = 35,              // 群聊天信息
    InformationTypeFileOnlineDataArrival = 37,              // 文件传输
    InformationTypeReturnFileDataArrival  = 39,              // 文件传输

    
    
    
    
    InformationTypeGetContactsRTData = 40,           // 获取我的所有联系人的在线状态、版本号，以及我的所有组的版本号
    InformationTypeGetFriendIDList = 41,             // 获取我的所有好友ID（C->S）
    InformationTypeGetAllContacts = 42,              // 获取我的所有联系人资料（C->S）
    InformationTypeAddFriend = 43,                   // 添加好友（C->S）
    InformationTypeRemoveFriend = 44,                // 删除好友（C->S）
    InformationTypeFriendRemovedNotify = 45,         // 通知客户端其被对方从好友中删除（S->C）
    InformationTypeFriendAddedNotif = 46,            // 通知客户端其被对方添加为好友（S->C）
    InformationTypeFileOffLineDataArrival = 47,      // 离线传输请求
    InformationTypeGetOfflineFile = 48,              // 请求离线文件
    

    InformationTypeSystemNotify4AllOnline = 80,     // 发送给所有在线用户的系统消息
    InformationTypeSystemNotify4Group = 81,         // 发送给某个组的系统消息
    InformationTypeHeartBeat = 82,                  // 用户发送心跳
    InformationTypeFileSendBear = 83,               // 记录文件传输结果保存到数据库
    
    InformationTypeChatPhoto = 100,               // 聊天信息 图片
    InformationTypeChatFile = 101,               // 聊天信息 文件
};
#pragma mark -- 通知的

#define NotiForServerStatusChange @"NotiForServerStatusChange"   // 服务器状态发生改变

#define NotiForLoginSuccess @"NotiForLoginSuccess"   // 登录成功


#define NotiForReceiveTypeUserStatusChange @"NotiForReceiveTypeUserStatusChange"   // 接收到 用户状态改变
#define NotiForReceiveTypeUpdateSelfState  @"NotiForReceiveTypeUpdateSelfState"    // 更新当前用户在线状态 成功

#define NotiForReceiveTypeSingOut @"NotiForReceiveTypeSingOut"   // 接收到 用户离线
#define NotiForReceiveTypeNewUserLogin @"NotiForReceiveTypeNewUserLogin"   // 接收到 服务器告诉用户有新的联系人登录
#define NotiForReceiveTypeChat @"NotiForReceiveTypeChat"   // 接收到 发送的消息
#define NotiForReceiveTypeUserInfoChange @"NotiForReceiveTypeUserInfoChange"   // 接收到 用户信息改变

typedef NS_ENUM(NSUInteger,MsgType) {
    MsgTypeText  = 0,
    MsgTypeImage = 1,
    MsgTypeAudio = 2,
    MsgTypeFile = 3,
    

};


typedef NS_ENUM(NSUInteger,UserStatus) {
    UserStatusOffLine = 0,            // 离线
    UserStatusOnline = 1,             // 在线
    UserStatusHide = 2,               // 隐身
    UserStatusAway = 3,               // 离开
    UserStatusBusy = 4,               // 繁忙
    UserStatusDontDisturb = 5,        // 勿扰
};
