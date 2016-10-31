//
//  PresentingAnimator.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/7.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "PresentingAnimator.h"
#import "FMEasing.h"
#import "UIView+SetRect.h"

@implementation PresentingAnimator

// 转场动画时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 1.f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // 另一个view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.y       = getScreenWidth();
    
    // 管理容器
    UIView *container = [transitionContext containerView];
    
    // 容器中添加推出的view
    [container addSubview:toView];
    
    // 动画时间
    CGFloat duration = [self transitionDuration:transitionContext];
    
    // 开始点 + 结束点
    CGPoint startPoint = toView.center;
    CGPoint endPoint   = container.center;
    
    // 关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath              = @"position";
    keyAnimation.values               = [FMEasing calculateFrameFromPoint:startPoint toPoint:endPoint
                                                                     func:ExponentialEaseOut frameCount:duration * 60.f];
    keyAnimation.duration             = duration;
    toView.center                     = container.center;
    [toView.layer addAnimation:keyAnimation forKey:nil];
    
    [GCDQueue executeInMainQueue:^{
        
        [transitionContext completeTransition:YES];
        
    } afterDelaySecs:duration];
}


@end
