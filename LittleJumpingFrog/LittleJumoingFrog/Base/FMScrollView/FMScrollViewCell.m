//
//  FMScrollViewCell.m
//  DTSPhone
//
//  Created by 王刚 on 2017/2/10.
//  Copyright © 2017年 DTS. All rights reserved.
//

#import "FMScrollViewCell.h"
#import "FMScrollView.h"

@implementation FMScrollViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)initView:(id)object frame:(CGRect)frame{
    self.object = [object objectForKey:@"data"];
    self.index = ((NSNumber *)[object objectForKey:@"index"]).intValue;
    self.frame = frame;
    self.canBeMovedToLeft = NO;
    self.canBeMovedToLeftWidth = 0;
    self.canBeLongPress = NO;
}
- (void)prepareForReuse{
    self.object = nil;
    self.index  = 0;
    self.canBeMovedToLeft = NO;
    self.canBeMovedToLeftWidth = 0;
    self.canBeLongPress = NO;
}

- (void) cellAppear{
    
}

- (void)cellRefreshAppearWithObject:(id)object{
    self.object = object;
}

- (void) resizeFrameWithExpandWidth:(CGFloat)expandWidth expandHeight:(CGFloat)expandHeight{
    FMScrollView * sv = (FMScrollView*) self.superview;
    [sv resizeFrameAtIndex:self.index expandWidth:expandWidth expandHeight:expandHeight];
}

- (void) movedToLeftViewWithOffsetX:(CGFloat)x orgFrame:(CGRect)orgFrame{
    
}


+ (CGFloat)calculateHeight:(id)object view:(FMScrollView *)view{
    return 0;
}
+ (CGFloat)calculateWidth:(id)object view:(FMScrollView*)view{
    return 0;
}
+ (CGFloat)heightOffset:(id)object view:(FMScrollView*)view{
    return 0;
}
+ (CGFloat)xOffset:(id)object view:(FMScrollView*)view{
    return 0;
}
+ (BOOL)fixedCell{
    return false;
}


@end
