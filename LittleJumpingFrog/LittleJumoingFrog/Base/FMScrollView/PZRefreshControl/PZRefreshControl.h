//
//  PZRefreshControl.h
//  PullToRefreshControlDemo
//
//  Created by cherry on 16/1/8.
//  Copyright © 2016年 Zhang Kai Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZRefreshControlStyle.h"

@interface PZRefreshControl : UIControl
{
@protected
    __weak UIScrollView *_scrollView;
}


@property (nonatomic, strong, readwrite) UIView *animationView;
@property (nonatomic) NSTimeInterval disappearingTimeInterval;
@property (nonatomic) CGFloat height;
@property (nonatomic, readwrite) CGFloat maxDistance;
@property (strong, readwrite, nonatomic) Class<PZRefreshControlStyle> styleClass;

- (instancetype)initWithRefreshTarget:(id)refreshTarget
                     andRefreshAction:(SEL)refreshAction
                          MaxDistance:(CGFloat)maxDistance
                               height:(CGFloat)height
                           styleClass:(Class)styleClass;

- (void)resetFrame;
- (void)dragging:(CGFloat)fractionDragged;
- (void)maxDistanceReached;
- (void)startRefreshing;
- (void)disappearing;
@end
