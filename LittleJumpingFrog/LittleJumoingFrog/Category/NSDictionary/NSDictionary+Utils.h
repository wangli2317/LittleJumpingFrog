//
//  NSDictionary+Utils.h
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Utils.h"

@interface NSDictionary (Utils)

- (id)objectAtKey:(id)aKey;
- (id)objectAtKey:(id)aKey defvalue:(NSString*)defvalue;

@end
