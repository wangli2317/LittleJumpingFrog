//
//  NSDictionary+DTSJson.h
//  DTSmogi
//
//  Created by 王刚 on 16/11/15.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DTSJson)
- (NSString *)jsonString: (NSString *)key;

- (NSDictionary *)jsonDict: (NSString *)key;
- (NSArray *)jsonArray: (NSString *)key;
- (NSArray *)jsonStringArray: (NSString *)key;


- (BOOL)jsonBool: (NSString *)key;
- (NSInteger)jsonInteger: (NSString *)key;
- (long long)jsonLongLong: (NSString *)key;
- (unsigned long long)jsonUnsignedLongLong:(NSString *)key;

- (double)jsonDouble: (NSString *)key;
@end
