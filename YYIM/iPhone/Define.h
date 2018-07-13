
#define serverHost  @"http://10.120.35.64:5533/"
#define UrlPath   [NSString stringWithFormat:@"%@%@",serverHost,@"RemotingService"]

#define CurrentUserId             [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserId"]]
#define setCurrentUserId(currentUserId)  [[NSUserDefaults standardUserDefaults] setValue:currentUserId forKey:@"CurrentUserId"]



#define NaviHeight 69
#define ContentHeight [UIScreen mainScreen].bounds.size.height - NaviHeight
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define FontNormal  [UIFont systemFontOfSize:14]
#define FontBig  [UIFont systemFontOfSize:16]



#define ColorBlack  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]



#define NotiForReceive @"NotiForReceive"
