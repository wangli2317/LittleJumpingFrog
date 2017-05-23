//
//  BackgroundLineView.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/11.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundLineView : UIView

/**
 *  Line color, default is grayColor.
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  Line width, default is 5.
 */
@property (nonatomic) CGFloat lineWidth;

/**
 *  Line gap, default is 3.
 */
@property (nonatomic) CGFloat lineGap;

/**
 *  Rotate value, default is 0.
 */
@property (nonatomic) CGFloat rotate;

/**
 *  Constructor method.
 *
 *  @param frame     The frame.
 *  @param lineWidth Line width.
 *  @param lineGap   Line gap.
 *  @param lineColor Line color.
 *  @param rotate    Rotate value.
 *
 *  @return BackgroundLineView object.
 */
+ (instancetype)backgroundLineViewWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineGap:(CGFloat)lineGap
                                  lineColor:(UIColor *)lineColor rotate:(CGFloat)rotate;

@end
