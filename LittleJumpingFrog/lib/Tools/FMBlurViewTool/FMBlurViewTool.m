//
//  FMBlurViewTool.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMBlurViewTool.h"

@implementation FMBlurViewTool
+ (void)blurView:(UIView *)view style:(UIBarStyle)style{
    UIToolbar *blurView = [[UIToolbar alloc] init];
    blurView.barStyle = style;
    blurView.frame = view.frame;
    [view addSubview:blurView];
}
@end
