//
//  NSMutableDictionary+DTSWeakReference.h
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (DTSWeakReference)

- (void)weak_setObject:(id)anObject forKey:(NSString *)aKey;

- (void)weak_setObjectWithDictionary:(NSDictionary *)dic;

- (id)weak_getObjectForKey:(NSString *)key;

@end
