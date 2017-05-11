//
//  FMInfiniteRotationView.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMInfiniteRotationView : UIView

/**
 *  How many seconds to rotate 1 π (s/π).
 */
@property (nonatomic) NSTimeInterval  speed;

/**
 *  Direction of rotation, default is YES.
 */
@property (nonatomic) BOOL    clockWise;

/**
 *  Start angle.
 */
@property (nonatomic) CGFloat startAngle;

/**
 *  Start rotate animation.
 */
- (void)startRotateAnimation;

/**
 *  Stop and reset animation.
 */
- (void)reset;


@end
