//
//  FMPublicCellMenuItemButton.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMPublicCellIconModel;

@interface FMPublicCellMenuItemButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame model:(FMPublicCellIconModel *)iconModel;
@end
