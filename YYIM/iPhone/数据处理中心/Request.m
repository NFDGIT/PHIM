//
//  Request.m
//  YYIM
//
//  Created by Jobs on 2018/7/10.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "Request.h"
#import "AFNetworking.h"
#import "FileManager.h"

#define outTimes 15
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
 上传图片

 @param image 图片对象
 @param receiveId 成功的回调
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)uploadImage:(UIImage *)image receiveId:(NSString *)receiveId progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    
    NSDictionary * param = @{@"accepterID":receiveId};
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    
    [manager POST:[NSString stringWithFormat:@"%@api/upload",serverUploadFileAddress] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
//        NSLog(@"%lld::%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
//        NSLog(@"%lld",uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        NSLog(@"%.2f",uploadProgress.fractionCompleted);
        NSLog(@"%f",uploadProgress.fractionCompleted);
        
        //打印下上传进度
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        

    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        if (success) {
            NSDictionary * result = responseObject;
            
            NSString * code = [NSString stringWithFormat:@"%@",result[@"code"]];
            NSString * msg = [NSString stringWithFormat:@"%@",result[@"msg"]];
            NSArray * data = [NSArray arrayWithArray:responseObject[@"data"]];
            
//            NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:result];
//            [data setValue:[NSString stringWithFormat:@"http://10.120.35.64:5533/%@/%@?width=%f&height=%f",receiveId,fileName,image.size.width,image.size.height] forKey:@"imgUrl"];
            
            success(code.integerValue,msg,data);
            
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        if (failure) {
            failure(error);
        }
    }];

}

/**
 上传文件
 
 @param url 文件
 @param receiveId 成功的回调
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)uploadFile:(NSURL *)url receiveId:(NSString *)receiveId progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];

    NSDictionary * param = @{@"accepterID":receiveId};
    NSData * data = [NSData dataWithContentsOfFile:url.absoluteString];
    if (!data) {
        if (failure) {
            failure([NSError new]);
        }
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"文件无效" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    fileName = url.absoluteString;
    
    [manager POST:[NSString stringWithFormat:@"%@api/upload",serverUploadFileAddress] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    
        
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
//
//        //        NSLog(@"%lld::%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
//        //        NSLog(@"%lld",uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
//        NSLog(@"%.2f",uploadProgress.fractionCompleted);
//        NSLog(@"%f",uploadProgress.fractionCompleted);
        
        //打印下上传进度
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
        
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        if (success) {
            NSDictionary * result = responseObject;
            
            NSString * code = [NSString stringWithFormat:@"%@",result[@"code"]];
            NSString * msg = [NSString stringWithFormat:@"%@",result[@"msg"]];
            NSArray * data = [NSArray arrayWithArray:responseObject[@"data"]];
            
            success(code.integerValue,msg,data);
            
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 下载文件
 
 @param url 文件
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)downloadFile:(NSURL *)url progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure{
    //创建传话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成后的回调
     filePath:最终的文件路径
     */

    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request
                                                                 progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                     //下载进度
                                                                     //打印下上传进度
                                                                     if (progress) {
                                                                         progress(downloadProgress.fractionCompleted);
                                                                     }
                                                
                                                                 }
                                                              destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                   
                                                                  
                                                                  //保存的文件路径
                                                                  NSString *fullPath = [[FileManager  getResourceFolder] stringByAppendingPathComponent:response.suggestedFilename];
                                                                  return [NSURL fileURLWithPath:fullPath];
                                                                  
                                                              }
                                                        completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                         
                                                            if (error) {
                                                                if (failure) {
                                                                    failure(error);
                                                                }
                                                            }else{
                                                                if (success) {
                                                                    success(200,@"下载成功",filePath);
                                                                }
                                                            }
                                                            
                                                            
//                                                            NSLog(@"%@",filePath);
                                                        }];
    
    //执行Task
    [download resume];

}
/**
 下载图片
 
 @param url 图片链接
 @param progress  进度
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)downloadImage:(NSURL *)url progress:(void(^)(float progress))progress success:(successBlock)success failure:(failureBlock)failure{
    [[SDWebImageManager sharedManager]loadImageWithURL:url options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progress) {
            progress((float)receivedSize / (float)expectedSize);
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (finished) {
            if (success) {
                success(200,@"成功",image);
            }
    
        }else{
            if (failure) {
                failure(error);
            }
            
        }
    }];
    
}

/**
 查询联系人
 
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserListSuccess:(successBlock)success failure:(failureBlock)failure{
    

//    NSString * httpHeader = [NSString stringWithFormat:@"%@%@",serverHost,@"RemotingService"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/FindAllUser" params:nil success:^(NSUInteger code, NSString *msg, id data) {
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
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/getmyinfo" params:param success:^(NSUInteger code, NSString *msg, id data) {
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
 获取用户信息
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)getUserInfo1WithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:idOrName forKey:@"idOrName"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/SearchUser" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            
            NSArray  * datas = data[@"data"];
            NSDictionary * datasFirstDic =[NSDictionary dictionaryWithDictionary:datas.firstObject];
            success(code,msg,datasFirstDic);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
//    {"code":"200","msg":"成功","data":[{"PassWord":"e10adc3949ba59abbe56e057f20f883e","UserName":"13383824275","RealName":"彭辉","ID":"13383824275","RoleId":"1|3|8","Groups":"","CreateTime":"2018-07-19T16:09:40","UnderWrite":"aaa","Department":null,"OrgPath":["1","3","8"],"IsInOrg":true,"HeadName":63,"PhotoContent":null,"State":"1","Version":31,"LastWords":"","IsGroup":false,"Sex":"保密","Phone":"13522220189","Email":"123456@qq.com","PhotoName":"2018522151034.Jpeg","Friends":"我的好友:","FriendDicationary":{"我的好友":[]},"DefaultFriendCatalog":"我的好友","UserStatus":0,"Tag":null,"OnlineOrHide":false,"OfflineOrHide":true}]}
}
/**
 添加好友
 @param idOrName id 或用户名
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)addFriendWithIdOrName:(NSString *)idOrName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:idOrName forKey:@"friendId"];
    [param setValue:catalogName forKey:@"catalogName"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/addfriend" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);

        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 删除好友
 @param idOrName id 或用户名
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)deleteFriendWithIdOrName:(NSString *)idOrName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:idOrName forKey:@"friendId"];

    [Request getWithUrlPath:UrlPath AndUrl:@"/removefriend" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 添加分组
 @param idOrName id 或用户名
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)addCatelogWithIdOrName:(NSString *)idOrName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:catalogName forKey:@"catalogName"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/addcatelogname" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 修改分组
 @param idOrName id 或用户名
 @param atalogOldName 旧名称
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)updateCatelogWithIdOrName:(NSString *)idOrName atalogOldName:(NSString *)atalogOldName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:atalogOldName forKey:@"atalogOldName"];
    [param setValue:catalogName forKey:@"catalogName"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/editcatelogname" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 移除分组
 @param idOrName id 或用户名
 @param catalogName 分组名称
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)deleteCatelogWithIdOrName:(NSString *)idOrName catalogName:(NSString *)catalogName success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:catalogName forKey:@"catalogName"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/removecatelogname" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 加群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)joinGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:groupId forKey:@"groupId"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/joingroup" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 退群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)quitGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:groupId forKey:@"groupId"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/quitgroup" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 解散群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)deleteGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:groupId forKey:@"groupId"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/deletegroup" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 创建群
 @param idOrName id 或用户名
 @param groupId 群ID
 @param groupName 群名称
 @param groupNote 群说明
 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)createGroupWithIdOrName:(NSString *)idOrName groupId:(NSString *)groupId groupName:(NSString *)groupName groupNote:(NSString *)groupNote success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:groupId forKey:@"groupId"];
    [param setValue:groupName forKey:@"groupName"];
    [param setValue:groupNote forKey:@"groupNote"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/creategroup" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 修改密码
 
 @param idOrName id 或用户名
 @param oldPassword 旧密码
 @param newPassword 新密码
 @param success 成功回调
 @param failure 失败回调
 */
+(void)updatePasswordWithIdOrName:(NSString *)idOrName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(successBlock)success  failure:(failureBlock)failure{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:CurrentUserId forKey:@"idOrName"];
    [param setValue:oldPassword forKey:@"oldPass"];
    [param setValue:newPassword forKey:@"newPass"];
    
    [Request getWithUrlPath:UrlPath AndUrl:@"/setpassword" params:param success:^(NSUInteger code, NSString *msg, id data) {
        if (success) {
            NSString * datas = data[@"data"];
            success(code,msg,datas);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
@end
