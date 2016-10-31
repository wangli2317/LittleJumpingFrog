//
//  PopAnimator.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "PopAnimator.h"
#import "UIView+SetRect.h"
#import "UIView+AnimationProperty.h"

@implementation PopAnimator
- (void)transitionAnimation {
    
    // http://stackoverflow.com/questions/25513300/using-custom-ios-7-transition-with-subclassed-uinavigationcontroller-occasionall
    [self.containerView insertSubview:self.toViewController.view belowSubview:self.fromViewController.view];
    
    UIViewController *controller = self.toViewController;
    
    controller.view.x = - getScreenWidth();
    
    [UIView animateWithDuration:self.transitionDuration - 0.1 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        controller.view.alpha          = 1.f;
        self.fromViewController.view.x = getScreenWidth();
        controller.view.x = 0;
        
    } completion:^(BOOL finished) {
        
        [self completeTransition];
    }];
}


@end
