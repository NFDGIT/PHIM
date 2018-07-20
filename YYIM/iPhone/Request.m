//
//  Request.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "Request.h"
#import "AFNetworking.h"

#define outTimes 20
@implementation Request
+ (void)postWithUrlPath:(NSString *)urlStr AndUrl:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    // 1.获取AFN的请求管理者
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
//    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",urlStr,url];
    // 3.发送请求
    
    [manger POST:urlPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary * result = responseObject;
            
            NSString * code = [NSString stringWithFormat:@"%@",result[@"code"]];
            NSString * msg = [NSString stringWithFormat:@"%@",result[@"msg"]];
            success(code.integerValue,msg,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
  
}
+ (void)getWithUrlPath:(NSString *)urlStr AndUrl:(NSString *)url params:(NSMutableDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    // 1.获取AFN的请求管理者
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    //    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    //网络延时设置15秒
    manger.requestSerializer.timeoutInterval = outTimes;
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",urlStr,url];
    // 3.发送请求
    
    [manger GET:urlPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary * result = responseObject;
            
            NSString * code = [NSString stringWithFormat:@"%@",result[@"code"]];
            NSString * msg = [NSString stringWithFormat:@"%@",result[@"msg"]];
            success(code.integerValue,msg,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
//    [manger POST:urlPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    
}
/**
 查询联系人
 
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserListSuccess:(successBlock)success failure:(failureBlock)failure{
    

    NSString * httpHeader = [NSString stringWithFormat:@"%@%@",serverHost,@"RemotingService"];
    
    [Request getWithUrlPath:httpHeader AndUrl:@"/FindAllUser" params:nil success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            success(code,msg,data[@"data"][@"Nodes"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 登陆
 @param userName 用户名
 @param passWord 密码
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:userName forKey:@"UserName"];
    [param setValue:passWord forKey:@"PassWord"];
    
    [Request postWithUrlPath:UrlPath AndUrl:@"/VerifyUser" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            success(code,msg,data[@"data"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 获取用户信息
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserInfoWithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:idOrName forKey:@"idOrName"];
    
    [Request postWithUrlPath:UrlPath AndUrl:@"/getmyinfo" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            success(code,msg,data[@"data"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
//    {
//        FriendDicationary = "[{\"Dicationary\":\"\U6211\U7684\U597d\U53cb\",\"Friend\":[]}]";
//        Groups = "[]";
//        HeadName = 63;
//        UnderWrite = aaa;
//        userID = 13383824275;
//        userName = "\U5f6d\U8f89";
//    }
    
}
/**
 查询好友
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getFriendsWithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:idOrName forKey:@"idOrName"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/SearchUser" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            success(code,msg,data[@"data"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
//    {"code":"200","msg":"成功","data":[{"PassWord":"e10adc3949ba59abbe56e057f20f883e","UserName":"13383824275","RealName":"彭辉","ID":"13383824275","RoleId":"1|3|8","Groups":"","CreateTime":"2018-07-19T16:09:40","UnderWrite":"aaa","Department":null,"OrgPath":["1","3","8"],"IsInOrg":true,"HeadName":63,"PhotoContent":null,"State":"1","Version":31,"LastWords":"","IsGroup":false,"Sex":"保密","Phone":"13522220189","Email":"123456@qq.com","PhotoName":"2018522151034.Jpeg","Friends":"我的好友:","FriendDicationary":{"我的好友":[]},"DefaultFriendCatalog":"我的好友","UserStatus":0,"Tag":null,"OnlineOrHide":false,"OfflineOrHide":true}]}
}
@end
