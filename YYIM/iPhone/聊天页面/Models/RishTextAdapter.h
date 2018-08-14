//
//  RishTextAdapter.h
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Text_tag.h"

@interface RishTextAdapter : NSObject
+(NSAttributedString *)getAttributedStringWithString:(NSString *)string;
+(NSString *)getStringWithAttributedString:(NSAttributedString *)attributedString;

@end
