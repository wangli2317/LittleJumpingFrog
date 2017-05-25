//
//  UIView+AnimationsListViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "UIView+AnimationsListViewController.h"

@implementation UIView (AnimationsListViewController)

+ (UILabel *)animationsListViewControllerNormalHeadLabel {
    
    // Title label.
    UILabel *headlinelabel                      = [UILabel new];
    headlinelabel.font                          = [UIFont AvenirLightWithFontSize:28.f];
    headlinelabel.textAlignment                 = NSTextAlignmentCenter;
    headlinelabel.textColor                     = [UIColor colorWithRed:0.329  green:0.329  blue:0.329 alpha:1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"LittleJumping"];
    headlinelabel.attributedText                = attributedString;
    [headlinelabel sizeToFit];
    
    return headlinelabel;
}

+ (UILabel *)animationsListViewControllerHeadLabel {
    
    // Title label.
    UILabel *headlinelabel                      = [UILabel new];
    headlinelabel.font                          = [UIFont AvenirLightWithFontSize:28.f];
    headlinelabel.textAlignment                 = NSTextAlignmentCenter;
    NSString *showString                        = @"LittleJumping";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:showString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, showString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.203  green:0.598  blue:0.859 alpha:1]
                             range:NSMakeRange(1, 1)];
    headlinelabel.attributedText                = attributedString;
    [headlinelabel sizeToFit];
    
    return headlinelabel;
}

@end
