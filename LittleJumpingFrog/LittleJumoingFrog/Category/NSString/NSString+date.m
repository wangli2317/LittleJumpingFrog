//
//  NSString+date.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/5.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "NSString+date.h"

@implementation NSString (date)
//时间转字符串
+ (NSString *)setUpTimeStringWithTime:(NSTimeInterval)time{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

@end
