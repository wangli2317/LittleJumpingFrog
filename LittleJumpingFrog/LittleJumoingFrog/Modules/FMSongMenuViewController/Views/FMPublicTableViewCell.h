//
//  FMPublicTableViewCell.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAKPlaybackIndicatorView.h>

@class FMPublicSongDetailModel,FMPublicTableViewCell;

typedef enum : NSUInteger {
    
    kNormalState,
    kSelectedState,
    
} ETableViewTapAnimationCellState;

@protocol PublicTableViewCellDelegate <NSObject>

- (void)clickButton:(UIButton *)button openMenuOfCell:(FMPublicTableViewCell *)cell;
- (void)clickCellMenuItemAtIndex:(NSInteger)index Cell:(FMPublicTableViewCell *)cell;
- (void)clickIndicatorView;

@end

@interface FMPublicTableViewCell : UITableViewCell
@property (nonatomic ,weak  ) id<PublicTableViewCellDelegate  > delegate;
@property (nonatomic ,assign) BOOL                          isOpenMenu;
@property (nonatomic ,weak  ) UIButton                      *menuButton;
@property (nonatomic, assign) NAKPlaybackIndicatorViewState indicatorViewState;
@property (nonatomic ,weak  ) FMPublicSongDetailModel       *detailModel;
- (void)setUpCellMenu;
+ (instancetype)publicTableViewCellcellWithTableView:(UITableView *)tableView;

@end

