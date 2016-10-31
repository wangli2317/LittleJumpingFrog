//
//  DismissAnimator.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "DismissAnimator.h"
#import "UIView+SetRect.h"
#import "UIView+AnimationProperty.h"

@implementation DismissAnimator

- (void)transitionAnimation {
    
    [UIView animateWithDuration:self.transitionDuration animations:^{
        
        self.toViewController.view.scale = 1.f;
        self.fromViewController.view.y   = getScreenHeight();
        
    } completion:^(BOOL finished) {
        
        [self completeTransition];
    }];
}

@end

