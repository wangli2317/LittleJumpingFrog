//
//  MBProgressHUD+DTS.h
//  DTSmogi
//
//  Created by 王刚 on 16/11/17.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (DTS)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;


@end
