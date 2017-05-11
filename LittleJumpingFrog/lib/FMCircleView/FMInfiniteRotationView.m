//
//  FMInfiniteRotationView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMInfiniteRotationView.h"

@interface FMInfiniteRotationView ()

@property (nonatomic) BOOL   didStartAnimation;

@end

@implementation FMInfiniteRotationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.clockWise = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(eventDidBecomeActive:)                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(eventDidBecomeActive:)                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(eventDidBecomeActive:)                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)startRotateAnimation {
    
    if (_didStartAnimation == NO) {
        
        _didStartAnimation = YES;
        [self rotateViewAnimationWithView:self];
    }
}

- (void)reset {
    
    [self.layer removeAllAnimations];
    _didStartAnimation = NO;
}

- (void)rotateViewAnimationWithView:(UIView *)view {
    
    NSTimeInterval tmpSpeed = (_speed <= 0) ? 1 : _speed;
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue         = @(_startAngle);
    rotationAnimation.toValue           = @(_clockWise ? (M_PI * 100000) : (-M_PI * 100000) + _startAngle);
    rotationAnimation.duration          = tmpSpeed * 100000;
    rotationAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [view.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)eventDidBecomeActive:(id)obj {
    
    NSNotification *fication = obj;
    
    if ([fication.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.alpha = 1.f;
            
            if (_didStartAnimation == YES) {
                
                [self rotateViewAnimationWithView:self];
            }
        }];
        
    } else if ([fication.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.alpha = 0.f;
        }];
        
    } else if ([fication.name isEqualToString:UIApplicationWillResignActiveNotification]) {
        
        [UIView animateWithDuration:0.1f animations:^{
            
            self.alpha = 0.f;
        }];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
