//
//  DTSWeakReference.m
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "DTSWeakReference.h"

DTSWeakReference makeWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

id weakReferenceNonretainedObjectValue(DTSWeakReference ref) {
    return ref ? ref() : nil;
}
