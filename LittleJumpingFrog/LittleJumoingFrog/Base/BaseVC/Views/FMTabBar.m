//
//  FMTabBar.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/7.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMTabBar.h"
#import "FMTabBarButton.h"


@interface FMTabBar()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, weak) UIButton *selectedButton;

@property (assign, nonatomic, getter = isBloom) BOOL bloom;

@end

@implementation FMTabBar

- (NSMutableArray *)buttons{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)setItems:(NSArray *)items{
    _items = items;
    for (UITabBarItem * item in _items) {
        
        FMTabBarButton *btn = [FMTabBarButton buttonWithType:UIButtonTypeCustom];
        btn.item = item;
        
        btn.tag = self.buttons.count;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        if (btn.tag == 0) {
            btn.selected = YES;;
        }
        
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
}

// 点击tabBarButton调用
-(void)btnClick:(UIButton *)button{
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    
    // 通知tabBarVc切换控制器，
    if ([_delegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
        [_delegate tabBar:self didClickButton:button.tag];
    }
}

// self.items UITabBarItem模型，有多少个子控制器就有多少个UITabBarItem模型
// 调整子控件的位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (self.items.count );
    CGFloat btnH = self.bounds.size.height;
    
    
    int i = 0;
    // 设置tabBarButton的frame
    for (UIView *tabBarButton in self.buttons) {

        btnX = i * btnW;
        tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
        i++;
    }

}

- (void)setTabBarSelectedIndexButton:(NSUInteger)selectedIndex{
    for (int i = 0; i < self.subviews.count; ++i) {
        UIButton *button = [self.subviews objectAtIndex:i];
        if (i == selectedIndex) {
            _selectedButton.selected = NO;
            button.selected = YES;
            _selectedButton = button;
        }
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIColor *color = UIColorFromRGB(0xdddddd);
    [color set];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2;
    
    [aPath moveToPoint:CGPointMake(0,0)];
    [aPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),0)];
    
    [aPath stroke];
}


@end
