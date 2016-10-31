//
//  PresentAnimator.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "PresentAnimator.h"
#import "UIView+SetRect.h"
#import "UIView+AnimationProperty.h"

@implementation PresentAnimator

- (void)transitionAnimation {
    
    // http://stackoverflow.com/questions/25588617/ios-8-screen-blank-after-dismissing-view-controller-with-custom-presentation
    [self.containerView addSubview:self.toViewController.view];
    
    self.toViewController.view.y = getScreenHeight();
    [UIView animateWithDuration:self.transitionDuration animations:^{
        
        self.fromViewController.view.scale = 0.95f;
        self.toViewController.view.y       = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self completeTransition];
    }];
}

@end

