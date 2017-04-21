//
//  DTSViewManager.m
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import "DTSViewManager.h"

#import "NSMutableDictionary+DTSWeakReference.h"
#import "NSDictionary+Utils.h"

@implementation DTSViewManager
static NSMutableDictionary *objmap = nil;

+ (instancetype)manager {
    static DTSViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DTSViewManager alloc]init];
    });
    return manager;
}

- (id) getInstanceFromName:(NSString*)className{
    if (objmap == nil){
        objmap = [[NSMutableDictionary alloc] init];
    }
    NSObject *obj = [objmap weak_getObjectForKey:className];
    if (obj==nil) {
        Class class = NSClassFromString(className);
        obj = [[class alloc] init];
        [objmap weak_setObject:obj forKey:className];
    }
    
    return obj;
}

- (id) getInstance:(Class)class{
    if (objmap == nil){
        objmap = [[NSMutableDictionary alloc] init];
    }
    NSString *className = NSStringFromClass(class);
    
    NSObject *obj = [objmap weak_getObjectForKey:className];
    if (obj==nil) {
        obj = [[class alloc] init];
        [objmap weak_setObject:obj forKey:className];
    }
    
    return obj;
}

- (id)isInObjectAt:(Class)class{
    if (objmap == nil){
        objmap = [[NSMutableDictionary alloc] init];
    }
    NSString *className = NSStringFromClass(class);
    
    NSObject *obj = [objmap weak_getObjectForKey:className];
    return obj;
}

- (void) addInstance:(id)obj{
    if (obj == nil){
        return;
    }
    if (objmap == nil){
        objmap = [[NSMutableDictionary alloc] init];
    }
    NSString *className = NSStringFromClass([obj class]);
    
    NSObject *oldobj = [objmap weak_getObjectForKey:className];
    if ([obj isEqual:oldobj]) {
        [objmap weak_setObject:obj forKey:className];
    }
    
}

- (void) removeInstance:(Class)class{
    NSObject *obj = [self getInstance:class];
    if (obj){
        NSString *className = NSStringFromClass(class);
        [objmap removeObjectForKey:className];
        obj = nil;
    }
}

- (void) clearInstance{
    [objmap removeAllObjects];
}


- (id)getInstance:(Class)class params:(NSDictionary *)params{
    
    id instance = [self getInstance:class];
    
    NSDictionary *propertys = [params objectAtKey:@"property"];
    [propertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            [instance setValue:obj forKey:key];
        }
    }];
    return instance;
}

- (id)getForceInstance:(Class)class paramsProspertys:(NSDictionary *)paramsProspertys{
    
    id instance = [self getInstance:class];
    
    NSDictionary *propertys = [paramsProspertys objectAtKey:@"property"];
    [propertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [instance setValue:obj forKey:key];
            
    }];
    return instance;
}


@end
