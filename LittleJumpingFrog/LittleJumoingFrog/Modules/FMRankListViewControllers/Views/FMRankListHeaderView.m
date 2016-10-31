//
//  FMRankListHeaderView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/26.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMRankListHeaderView.h"

@implementation FMRankListHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        UILabel *headerLabel = [FMCreatTool labelWithView:self];
        headerLabel.text = @"小跳蛙音乐巅峰榜";
        headerLabel.font =   [UIFont fontWithName:@"GillSans-Italic" size:16.f];
        [headerLabel sizeToFit];
        
        headerLabel.frame = CGRectMake((getScreenWidth() - CGRectGetWidth(headerLabel.frame)) * 0.5, FMCommonSpacing , CGRectGetWidth(headerLabel.frame), CGRectGetHeight(headerLabel.frame));
        
        self.frame = CGRectMake(0, 0, getScreenWidth(), CGRectGetHeight(headerLabel.frame) + 2 * FMCommonSpacing - FMVerticalSpacing);
    }
    return self;
}

@end
