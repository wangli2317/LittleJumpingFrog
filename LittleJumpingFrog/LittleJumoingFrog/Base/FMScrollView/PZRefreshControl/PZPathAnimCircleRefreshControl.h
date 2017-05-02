//
//  PZPathAnimCircleRefreshControl.h
//  PullToRefreshControlDemo
//
//  Created by cherry on 16/1/8.
//  Copyright © 2016年 Zhang Kai Yu. All rights reserved.
//

#import "PZRefreshControl.h"

@interface PZPathAnimCircleRefreshControl : PZRefreshControl
- (instancetype)initWithRefreshTarget:(id)refreshTarget
                     andRefreshAction:(SEL)refreshAction
                           styleClass:(Class)styleClass;
@end
