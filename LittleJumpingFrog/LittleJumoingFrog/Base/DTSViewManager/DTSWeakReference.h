//
//  DTSWeakReference.h
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^DTSWeakReference)(void);

DTSWeakReference makeWeakReference(id object);

id weakReferenceNonretainedObjectValue(DTSWeakReference ref);

