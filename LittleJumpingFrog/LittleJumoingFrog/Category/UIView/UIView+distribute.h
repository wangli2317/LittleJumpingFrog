//
//  UIView+distribute.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (distribute)
- (void)distributeViewsHorizontallyWith:(NSArray *)views margin:(CGFloat)margin;
- (void)distributeViewsVerticallyWith:(NSArray *)views margin:(CGFloat)margin;
- (void)distributeViewsHorizontallyWith:(NSArray *)views;
- (void)distributeViewsVerticallyWith:(NSArray *)views;
@end
