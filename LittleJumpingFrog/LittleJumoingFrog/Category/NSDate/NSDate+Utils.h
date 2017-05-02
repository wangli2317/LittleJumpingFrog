//
//  NSDate+Utils.h
//  DTSmogi
//
//  Created by 王刚 on 16/11/21.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

+ (NSString *)getTimeStringTimeDate:(NSDate *)date dateFormat:(NSString *)dateFormatString;

+ (NSString *)getTimeStringTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormatString;

+ (NSString *)getDateSpWithTimeStr:(NSString *)timeStr;

+ (NSDate *)getDateWithTimeStr:(NSString *)timeStr;

//给定时间返回月份
+ (NSString *)getMonthWithDate:(NSDate *)date;

//根据utc时间 返回当地时间
+ (NSDate *)getLocalFromUTC:(NSString *)utc;

//获取当前时间戳
+ (NSInteger)getTimeSp;
@end
