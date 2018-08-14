//
//  NSDate+Helper.m
//  YYIM
//
//  Created by Jobs on 2018/8/8.
//  Copyright © 2018年 Jobs. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)
+(NSDateComponents *)getComponents{

    
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear |
    
    NSCalendarUnitMonth |
    
    NSCalendarUnitDay |
    
    NSCalendarUnitWeekday |
    
    NSCalendarUnitDay |
    
    NSCalendarUnitMinute |
    
    NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    return comps;
//    NSInteger weekIndex = [comps weekday];
//    return arrWeek[weekIndex];
}
+(NSString *)getWeekDay{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    return arrWeek[[[self getComponents] weekday]];
}
+(NSInteger)getDay{
    return [[self getComponents] day];
}
+(NSInteger)getMonth{
    return [[self getComponents] month];
}
@end
