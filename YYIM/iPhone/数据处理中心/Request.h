//
//  Request.h
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlock)(NSUInteger code,NSString * msg, id data);
typedef void (^failureBlock)(NSError *error);
@interface Request : NSObject

+ (void)postWithUrlPath:(NSString *)urlStr AndUrl:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 查询联系人

 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserListSuccess:(successBlock)success  failure:(failureBlock)failure;
/**
 上传图片
 
 @param image 图片对象
 @param receiveId 成功的回调
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)uploadImage:(UIImage *)image receiveId:(NSString *)receiveId  progress:(void(^)(float progress))progress  success:(successBlock)success failure:(failureBlock)failure;
/**
 上传文件
 
 @param url 文件
 @param receiveId 成功的回调
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)uploadFile:(NSURL *)url receiveId:(NSString *)receiveId progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure;
/**
 下载文件
 
 @param url 文件
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)downloadFile:(NSURL *)url progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure;
/**
 下载图片
 
 @param url 图片链接
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)downloadImage:(NSURL *)url progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure;
/**
 登陆
 @param userName 用户名
 @param passWord 密码
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord success:(successBlock)success  failure:(failureBlock)failure;
/**
 获取用户信息
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserInfoWithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure;
/**
 获取用户信息1
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserInfo1WithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure;
/**
 添加好友
 @param idOrName id 或用户名
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)addFriendWithIdOrName:(NSString *)idOrName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure;
/**
 删除好友
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)deleteFriendWithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure;
/**
 添加分组
 @param idOrName id 或用户名
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)addCatelogWithIdOrName:(NSString *)idOrName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure;
/**
 修改分组
 @param idOrName id 或用户名
 @param atalogOldName 旧名称
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)updateCatelogWithIdOrName:(NSString *)idOrName atalogOldName:(NSString *)atalogOldName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure;
/**
 移除分组
 @param idOrName id 或用户名
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)deleteCatelogWithIdOrName:(NSString *)idOrName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure;
/**
 加群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)joinGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId success:(successBlock)success  failure:(failureBlock)failure;
/**
 退群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)quitGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId success:(successBlock)success  failure:(failureBlock)failure;
/**
 解散群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)deleteGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId success:(successBlock)success  failure:(failureBlock)failure;
/**
 创建群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param groupName 群名称
 @param groupNote 群说明
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)createGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId groupName:(NSString *)groupName groupNote:(NSString *)groupNote success:(successBlock)success  failure:(failureBlock)failure;
/**
 修改密码

 @param idOrName id 或用户名
 @param oldPassword 旧密码
 @param newPassword 新密码
 @param success 成功回调
 @param failure 失败回调
 */

+(void)updatePasswordWithIdOrName:(NSString *)idOrName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(successBlock)success  failure:(failureBlock)failure;
@end
