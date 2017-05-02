//
//  FMScrollViewCell.h
//  DTSPhone
//
//  Created by 王刚 on 2017/2/10.
//  Copyright © 2017年 DTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMScrollView;


@interface FMScrollViewCell : UIView

@property (nonatomic, strong) id object;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL canBeMovedToLeft;
@property (nonatomic, assign) CGFloat canBeMovedToLeftWidth;
@property (nonatomic, assign) BOOL canBeLongPress;

- (void)initView:(id)object frame:(CGRect)frame;
- (void)prepareForReuse;
- (void)cellAppear;
- (void)cellRefreshAppearWithObject:(id)object;
- (void)resizeFrameWithExpandWidth:(CGFloat)expandWidth expandHeight:(CGFloat)expandHeight;
- (void)movedToLeftViewWithOffsetX:(CGFloat)x orgFrame:(CGRect)orgFrame;

+ (BOOL)fixedCell;

+ (CGFloat)calculateWidth:(id)object view:(FMScrollView*)view;
+ (CGFloat)calculateHeight:(id)object view:(FMScrollView*)view;
+ (CGFloat)heightOffset:(id)object view:(FMScrollView*)view;
+ (CGFloat)xOffset:(id)object view:(FMScrollView*)view;


@end
