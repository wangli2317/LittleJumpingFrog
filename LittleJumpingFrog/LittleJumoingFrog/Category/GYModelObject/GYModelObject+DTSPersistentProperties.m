//
//  GYModelObject+DTSPersistentProperties.m
//  DTSClassRoom
//
//  Created by 王刚 on 2017/3/15.
//  Copyright © 2017年 TAL. All rights reserved.
//

#import "GYModelObject+DTSPersistentProperties.h"

@implementation GYModelObject (DTSPersistentProperties)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (NSArray *)persistentProperties {
    NSArray *properties = nil;
    
    if (!properties) {
        
        unsigned int outCount, i;
        // 获取对象里的属性列表
        objc_property_t * selfProperties = class_copyPropertyList(self, &outCount);
        
        NSMutableArray *propertiesMutableArray = [NSMutableArray arrayWithCapacity:outCount];
        
        for (i = 0; i < outCount; i++) {
            objc_property_t property =selfProperties[i];
            //  属性名转成字符串
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            // 判断该属性是否存在
            [propertiesMutableArray addObject:propertyName];
            
        }
        free(selfProperties);
        
        properties = [propertiesMutableArray copy];
    }
    return properties;
}

#pragma clang diagnostic pop


@end
