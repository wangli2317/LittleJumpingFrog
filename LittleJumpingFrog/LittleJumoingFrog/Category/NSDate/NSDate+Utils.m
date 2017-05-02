//
//  NSDate+Utils.m
//  DTSmogi
//
//  Created by 王刚 on 16/11/21.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

+ (NSString *)getTimeStringTimeDate:(NSDate *)date dateFormat:(NSString *)dateFormatString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormatString;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getMonthWithDate:(NSDate *)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;//NSMonthCalendarUnit
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%td",[dd month]];
}

+ (NSString *)getTimeStringTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormatString{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormatString;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDateSpWithTimeStr:(NSString *)timeStr{
    NSDate* date =  [NSDate getDateWithTimeStr:timeStr];
    return [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
}

+ (NSDate *)getDateWithTimeStr:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:timeStr];
}


+ (NSDate *)getLocalFromUTC:(NSString *)utc{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *ldate = [dateFormatter dateFromString:utc];
    
    return ldate;
}


+ (NSInteger)getTimeSp{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    return  [datenow timeIntervalSince1970];
    
}


@end
