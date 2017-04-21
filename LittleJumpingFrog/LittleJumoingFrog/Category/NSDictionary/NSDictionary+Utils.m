//
//  NSDictionary+Utils.m
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (id)objectAtKey:(id)aKey{
    NSObject *obj = [self objectForKey:aKey];
    if(obj.isEmpty){
        return [obj isKindOfClass:[NSArray class]]?[[NSArray alloc]init]:@"";
    }else{
        return obj;
    }
}

- (id)objectAtKey:(id)aKey defvalue:(NSString*)defvalue{
    NSObject *obj = [self objectForKey:aKey];
    if(obj.isEmpty){
        return [obj isKindOfClass:[NSArray class]]?[[NSArray alloc]init ]:defvalue;
    }else{
        return obj;
    }
}

@end
