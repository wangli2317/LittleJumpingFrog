//
//  PushAnimator.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "PushAnimator.h"
#import "UIView+SetRect.h"
#import "UIView+AnimationProperty.h"

@implementation PushAnimator
- (void)transitionAnimation {
    
    // http://stackoverflow.com/questions/25588617/ios-8-screen-blank-after-dismissing-view-controller-with-custom-presentation
    [self.containerView addSubview:self.toViewController.view];
    
    UIViewController *controller = self.fromViewController;
    
    controller.view.x = 0;
    self.toViewController.view.x = getScreenWidth();
    [UIView animateWithDuration:self.transitionDuration - 0.1f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        controller.view.alpha        = 0.f;
        self.toViewController.view.x = 0;
        controller.view.x = - getScreenWidth();
        
    } completion:^(BOOL finished) {
        
        [self completeTransition];
    }];
}


@end
