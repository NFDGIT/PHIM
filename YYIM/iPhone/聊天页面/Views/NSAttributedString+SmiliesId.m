//
//  NSAttributedString+SmiliesId.m
//  YYIM
//
//  Created by Jobs on 2018/7/12.
//  Copyright © 2018年 Jobs. All rights reserved.
//
#import <objc/runtime.h>

static void *smiliesIdKey = &smiliesIdKey;

#import "NSAttributedString+SmiliesId.h"

@implementation NSAttributedString (SmiliesId)
-(NSString *)smiliesId{
     return objc_getAssociatedObject(self, smiliesIdKey);
}
-(void)setSmiliesId:(NSString *)smiliesId{
    objc_setAssociatedObject(self, smiliesIdKey, smiliesId, OBJC_ASSOCIATION_RETAIN);
}
@end
