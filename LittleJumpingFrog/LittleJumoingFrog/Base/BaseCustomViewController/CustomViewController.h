//
//  CustomViewController.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/5.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewController : UIViewController
/**
 *  Screen's width.
 */
@property (nonatomic) CGFloat  width;

/**
 *  Screen's height.
 */
@property (nonatomic) CGFloat  height;

/**
 *  Base config.
 */
- (void)setup;

/**
 *  You can only use this method when the current controller is an UINavigationController's rootViewController.
 */
- (void)useInteractivePopGestureRecognizer;

/**
 *  You can use this property when this controller is pushed by an UINavigationController.
 */
@property (nonatomic)  BOOL  enableInteractivePopGestureRecognizer;

/**
 *  If this controller is managed by an UINavigationController, you can use this method to pop.
 *
 *  @param animated Animated or not.
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  If this controller is managed by an UINavigationController, you can use this method to pop to the rootViewController.
 *
 *  @param animated Animated or not.
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated;

@end
