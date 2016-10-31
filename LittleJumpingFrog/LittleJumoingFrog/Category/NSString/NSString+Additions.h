//
//  NSString+Additions.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/14.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
+ (BOOL)isStringEmpty:(NSString *)string;
+ (NSNumber *)covertToNumber:(NSString *)numberString;
+ (NSString *)timestampString;
+ (NSString *)stringWithMD5OfFile:(NSString *) path;
- (NSString *)md5Hash;
+ (NSString *)randomStringWithLength:(int)len;
+ (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval;
@end
