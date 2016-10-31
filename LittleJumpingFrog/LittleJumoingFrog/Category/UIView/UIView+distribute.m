//
//  UIView+distribute.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "UIView+distribute.h"

@implementation UIView (distribute)

- (void)distributeViewsHorizontallyWith:(NSArray *)views margin:(CGFloat)margin{
    NSMutableArray *assistViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < views.count - 1; i ++) {
        UIView *assistView = [[UIView alloc] init];
        [assistViewArray addObject:assistView];
        [self addSubview:assistView];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    UIView *firstView = views.firstObject;
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(margin);
    }];
    UIView *firstAssistView = assistViewArray.firstObject;
    [firstAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstView.mas_right);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    UIView *nextAssistView = firstAssistView;
    for (NSInteger i = 0; i < views.count - 2; i ++) {
        UIView *view = views[i + 1];
        UIView *assistView = assistViewArray[i + 1];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nextAssistView.mas_right);
            make.centerY.equalTo(nextAssistView.mas_centerY);
        }];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right);
            make.centerY.equalTo(view.mas_centerY);
            make.width.equalTo(nextAssistView.mas_width);
        }];
        nextAssistView = assistView;
    }
    UIView *lastView = views.lastObject;
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(margin * (-1));
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    [nextAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_left);
    }];
}

- (void)distributeViewsVerticallyWith:(NSArray *)views margin:(CGFloat)margin{
    NSMutableArray *assistViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < views.count - 1; i ++) {
        UIView *assistView = [[UIView alloc] init];
        [assistViewArray addObject:assistView];
        [self addSubview:assistView];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
        }];
    }
    UIView *firstView = views.firstObject;
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(margin);
    }];
    UIView *firstAssistView = assistViewArray.firstObject;
    [firstAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom);
        make.centerX.equalTo(firstView.mas_centerX);
    }];
    UIView *nextAssistView = firstAssistView;
    for (NSInteger i = 0; i < views.count - 2; i ++) {
        UIView *view = views[i + 1];
        UIView *assistView = assistViewArray[i + 1];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextAssistView.mas_bottom);
            make.centerX.equalTo(nextAssistView.mas_centerX);
        }];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom);
            make.centerX.equalTo(view.mas_centerX);
            make.height.equalTo(nextAssistView.mas_height);
        }];
        nextAssistView = assistView;
    }
    UIView *lastView = views.lastObject;
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(margin * (-1));
        make.centerX.equalTo(firstView.mas_centerX);
    }];
    [nextAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_top);
    }];
}

- (void) distributeViewsHorizontallyWith:(NSArray*)views{
    NSMutableArray *assistViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < views.count + 1; i ++) {
        UIView *assistView = [[UIView alloc] init];
        [assistViewArray addObject:assistView];
        [self addSubview:assistView];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    UIView *firstAssistView = assistViewArray.firstObject;
    [firstAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    UIView *nextAssistView = firstAssistView;
    for (NSInteger i = 0; i < views.count; i ++) {
        UIView *view = views[i];
        UIView *assistView = assistViewArray[i + 1];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nextAssistView.mas_right);
            make.centerY.equalTo(nextAssistView.mas_centerY);
        }];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right);
            make.centerY.equalTo(view.mas_centerY);
            make.width.equalTo(nextAssistView.mas_width);
        }];
        nextAssistView = assistView;
    }
    [nextAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
    }];
}

- (void) distributeViewsVerticallyWith:(NSArray*)views{
    NSMutableArray *assistViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i < views.count + 1; i ++) {
        UIView *assistView = [[UIView alloc] init];
        [assistViewArray addObject:assistView];
        [self addSubview:assistView];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
        }];
    }
    UIView *firstAssistView = assistViewArray.firstObject;
    [firstAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    UIView *nextAssistView = firstAssistView;
    for (NSInteger i = 0; i < views.count; i ++) {
        UIView *view = views[i];
        UIView *assistView = assistViewArray[i + 1];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nextAssistView.mas_bottom);
            make.centerX.equalTo(nextAssistView.mas_centerX);
        }];
        [assistView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom);
            make.centerX.equalTo(view.mas_centerX);
            make.height.equalTo(nextAssistView.mas_height);
        }];
        nextAssistView = assistView;
    }
    [nextAssistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
}

@end
