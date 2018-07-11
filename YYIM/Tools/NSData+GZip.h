//
//  NSData+GZip.h
//  YYIM
//
//  Created by Jobs on 2018/7/11.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GZip)
//压缩
+ (NSData *)gzipDeflate:(NSData*)data;
//解压缩
+ (NSData *)gzipInflate:(NSData*)data;
@end
