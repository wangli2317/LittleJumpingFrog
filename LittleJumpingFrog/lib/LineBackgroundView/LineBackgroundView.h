//
//  LineBackgroundView.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineBackgroundView : UIView

@property (nonatomic) CGFloat            lineWidth;
@property (nonatomic) CGFloat            lineGap;
@property (nonatomic, strong) UIColor   *lineColor;

- (void)buildView;
+ (instancetype)createViewWithFrame:(CGRect)frame lineWidth:(CGFloat)width lineGap:(CGFloat)lineGap lineColor:(UIColor *)color;

@end

