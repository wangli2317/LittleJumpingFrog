//
//  CustomNavigationController.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/5.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface CustomNavigationController : UINavigationController

/**
 *  Init with rootViewController.
 *
 *  @param rootViewController An UIViewController used as rootViewController.
 *  @param hidden             Navigation bar hide or not.
 *
 *  @return CustomNavigationController object.
 */
- (instancetype)initWithRootViewController:(CustomViewController *)rootViewController setNavigationBarHidden:(BOOL)hidden;

- (void)clickMusicIndicator;

- (void)clickMusicCell;
@end
