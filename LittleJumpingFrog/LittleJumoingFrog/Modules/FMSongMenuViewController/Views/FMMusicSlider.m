//
//  FMMusicSlider.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/12.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMMusicSlider.h"

@implementation FMMusicSlider

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImage *thumbImage = [UIImage imageNamed:@"music_slider_circle"];
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 10 ;
    rect.size.width = rect.size.width + 20;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}


@end
