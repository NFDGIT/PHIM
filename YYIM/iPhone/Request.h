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
 登陆
 @param userName 用户名
 @param passWord 密码
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord success:(successBlock)success  failure:(failureBlock)failure;
/**
 查询好友
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)searchUserWithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure;

@end
