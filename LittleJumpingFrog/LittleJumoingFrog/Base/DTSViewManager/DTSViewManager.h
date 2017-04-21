//
//  DTSViewManager.h
//  DTSmogi
//
//  Created by 王刚 on 16/12/1.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTSViewManager : NSObject


+ (instancetype)manager;

- (id) getInstanceFromName:(NSString*)className;
- (id) getInstance:(Class)className;

- (id) isInObjectAt:(Class)className;

- (void) addInstance:(id)obj;
- (void) removeInstance:(Class)className;
- (void) clearInstance;

- (id)getInstance:(Class)className params:(NSDictionary *)params;

//不使用运行时判断属性列表,强制KVC加入.如果没有属性,将直接崩溃
- (id)getForceInstance:(Class)className paramsProspertys:(NSDictionary *)paramsProspertys;
@end
