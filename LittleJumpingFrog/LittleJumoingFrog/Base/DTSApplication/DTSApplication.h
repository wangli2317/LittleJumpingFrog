//
//  DTSApplication.h
//  DTSmogi
//
//  Created by 王刚 on 16/11/29.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreStatus.h"

@interface DTSApplication : NSObject
//网络状态
@property(nonatomic,assign) CoreNetWorkStatus status;
//语言
@property(nonatomic,copy  ) NSString *lang;

+ (instancetype) application;

- (void) whetherFirstUse;

//initapp
- (void)initAppSuccess:(void (^)(id data , NSString * message))success failed:(void (^)(NSString * message)) failed;

//更改rootviewController
- (void)switchRootController:(UIViewController *)viewController options:(UIViewAnimationOptions)options;

//资源bundle名称
- (NSString *)getBundleName;
@end
