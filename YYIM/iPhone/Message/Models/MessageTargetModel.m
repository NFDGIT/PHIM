//
//  MessageTargetModel.m
//  YYIM
//
//  Created by Jobs on 2018/7/16.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "MessageTargetModel.h"

@implementation MessageTargetModel
-(id)valueForKey:(NSString *)key{
    return [NSString stringWithFormat:@"%@",[super valueForKey:key]];
    
}
@end
