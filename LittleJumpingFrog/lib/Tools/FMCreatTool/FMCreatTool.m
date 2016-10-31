//
//  FMCreatTool.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMCreatTool.h"

@implementation FMCreatTool
+ (UIView *)viewWithView:(UIView *)superView{
    UIView *view = [[UIView alloc] init];
    [superView addSubview:view];
    return view;
}

+ (UIImageView *)imageViewWithView:(UIView *)superView{
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    return imageView;
}

+ (UIScrollView *)scrollViewWithView:(UIView *)superView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [superView addSubview:scrollView];
    return scrollView;
}

+ (UIImageView *)imageViewWithView:(UIView *)superView size:(CGSize)size{
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return imageView;
}

+ (UITableView *)tableViewWithView:(UIView *)superView{
    UITableView *tableView = [[UITableView alloc] init];
    [superView addSubview:tableView];
    return tableView;
}

+ (UIButton *)buttonWithView:(UIView *)superView{
    return [self buttonWithView:superView image:nil state:UIControlStateNormal];
}

+ (UIButton *)buttonWithView:(UIView *)superView image:(UIImage *)image state:(UIControlState)state{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:state];
    [superView addSubview:button];
    return button;
}

+ (UIButton *)buttonWithView:(UIView *)superView image:(UIImage *)image state:(UIControlState)state size:(CGSize)size{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:state];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return button;
}

+ (UILabel *)labelWithView:(UIView *)superView{
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview:label];
    return label;
}

+ (UILabel *)labelWithView:(UIView *)superView size:(CGSize)size{
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return label;
}
@end
