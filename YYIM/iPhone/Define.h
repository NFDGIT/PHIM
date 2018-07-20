
#define serverHost  @"http://10.120.35.64:5533/"
#define UrlPath   [NSString stringWithFormat:@"%@%@",serverHost,@"RemotingService"]



#define NaviHeight 69
#define ContentHeight [UIScreen mainScreen].bounds.size.height - NaviHeight
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define FontNormal  [UIFont systemFontOfSize:14]
#define FontBig  [UIFont systemFontOfSize:16]
#define FontSmall  [UIFont systemFontOfSize:12]



#define ColorBlack  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]



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

#define CurrentUserStatus             [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserStatus"]
#define setCurrentUserStatus(currentUserStatus)  [[NSUserDefaults standardUserDefaults] setInteger:currentUserStatus forKey:@"CurrentUserStatus"];


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
    
    

    InformationTypeSystemNotify4AllOnline = 80,     // 发送给所有在线用户的系统消息
    InformationTypeSystemNotify4Group = 81,         // 发送给某个组的系统消息
    InformationTypeHeartBeat = 82,                  // 用户发送心跳
    InformationTypeFileSendBear = 83,               // 记录文件传输结果保存到数据库
};
#pragma mark -- 通知的
#define NotiForReceiveTypeUserStatusChange @"NotiForReceiveTypeUserStatusChange"   // 接收到 用户状态改变


#define NotiForReceiveTypeSingOut @"NotiForReceiveTypeSingOut"   // 接收到 用户离线
#define NotiForReceiveTypeNewUserLogin @"NotiForReceiveTypeNewUserLogin"   // 接收到 服务器告诉用户有新的联系人登录
#define NotiForReceiveTypeChat @"NotiForReceiveTypeChat"   // 接收到 发送的消息
#define NotiForReceiveTypeUserInfoChange @"NotiForReceiveTypeUserInfoChange"   // 接收到 用户信息改变




typedef NS_ENUM(NSUInteger,UserStatus) {
    UserStatusOffLine = 0,            // 离线
    UserStatusOnline = 1,             // 在线
    UserStatusHide = 2,               // 隐身
    UserStatusAway = 3,               // 离开
    UserStatusBusy = 4,               // 繁忙
    UserStatusDontDisturb = 5,        // 勿扰
};
