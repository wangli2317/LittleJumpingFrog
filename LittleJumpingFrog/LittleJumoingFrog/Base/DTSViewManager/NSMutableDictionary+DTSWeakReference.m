//
//  NSMutableDictionary+DTSWeakReference.m
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "NSMutableDictionary+DTSWeakReference.h"
#import "DTSWeakReference.h"

@implementation NSMutableDictionary (DTSWeakReference)

- (void)weak_setObject:(id)anObject forKey:(NSString *)aKey {
    [self setObject:makeWeakReference(anObject) forKey:aKey];
}

- (void)weak_setObjectWithDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary.allKeys) {
        [self setObject:makeWeakReference(dictionary[key]) forKey:key];
    }
}

- (id)weak_getObjectForKey:(NSString *)key {
    return weakReferenceNonretainedObjectValue(self[key]);
}


@end
