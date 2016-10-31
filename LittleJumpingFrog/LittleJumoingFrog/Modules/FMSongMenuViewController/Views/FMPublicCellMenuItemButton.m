//
//  FMPublicCellMenuItemButton.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPublicCellMenuItemButton.h"
#import "FMPublicCellIconModel.h"

@implementation FMPublicCellMenuItemButton
- (instancetype)initWithFrame:(CGRect)frame model:(FMPublicCellIconModel *)model{
    if (self = [super initWithFrame:frame]) {
        [self settingItemButtonWithModel:model];
    }
    return self;
}
- (void)settingItemButtonWithModel:(FMPublicCellIconModel *)model{
    //图片
    UIImageView *image = [[UIImageView alloc] init];

    image.image = [UIImage imageNamed:model.icon];
    [image sizeToFit];
    [self addSubview:image];
    image.frame = CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(image.frame)) * 0.5, 10, CGRectGetWidth(image.frame), CGRectGetHeight(image.frame));
    
    //文案
    UILabel *title = [[UILabel alloc] init];

    title.text = model.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = FMSmallFont;
    title.textColor = FMMainColor;
    [title sizeToFit];
    [self addSubview:title];
    title.frame = CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(title.frame)) * 0.5, CGRectGetHeight(self.frame) - CGRectGetHeight(title.frame)  ,CGRectGetWidth(title.frame), CGRectGetHeight(title.frame));
}

@end
