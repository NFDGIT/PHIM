//
//  UIImage+Text_tag.m
//  YYIM
//
//  Created by Jobs on 2018/8/14.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "UIImage+Text_tag.h"
#import <objc/runtime.h>

static void *text_tagKey = &text_tagKey;

@implementation UIImage (text_tag)


//getter
- (NSString *)text_tag {
    return  objc_getAssociatedObject(self, &text_tagKey);
}
//setter
- (void)setText_tag:(NSString *)text_tag {
    objc_setAssociatedObject(self,  &text_tagKey, text_tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
