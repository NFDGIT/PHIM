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
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)uploadImage:(UIImage *)image receiveId:(NSString *)receiveId  success:(successBlock)success failure:(failureBlock)failure;

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
@end
