//
//  FMTabBar.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/7.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMTabBar;

@protocol FMTabBarDelegate <NSObject>

@optional

- (void)tabBar:(FMTabBar *)tabBar didClickButton:(NSInteger)index;

@end

@interface FMTabBar : UIView

// items:保存每一个按钮对应tabBarItem模型
@property (nonatomic, strong) NSArray <UITabBarItem *> * items;

@property (nonatomic, weak) id<FMTabBarDelegate> delegate;

- (void)setTabBarSelectedIndexButton:(NSUInteger)selectedIndex;
@end

