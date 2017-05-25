//
//  FMSongListViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMSongListViewController.h"
#import "CustomNavigationController.h"

#import "FMBlurViewTool.h"

#import "FMPublicHeadView.h"
#import "FMPublicTableView.h"
#import "BackgroundLineView.h"

#import "FMPublicSonglistModel.h"
#import "FMPublicMusictablesModel.h"
#import "FMPublicSongDetailModel.h"

#import "UIView+Animations.h"
#import "UIView+AnimationsListViewController.h"
#import "UIView+GlowView.h"

@interface FMSongListViewController ()<FMPublicTableViewDelegate>
@property (nonatomic ,strong) FMPublicTableView *tableView;
@property (nonatomic ,strong) FMPublicHeadView *headView;

@property (nonatomic ,strong) UIImageView *backgroudImageView;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;

@property (nonatomic ,strong) UIVisualEffectView *visualEffectView;
@end

@implementation FMSongListViewController

- (void)setup {
    [super setup];
    
    //背景图片
    [self setUpBackGroundView];
    
    [self configureTitleView];

    self.headView = [[FMPublicHeadView alloc] initWithFullHead:YES];
    
    
    self.tableView = [[FMPublicTableView alloc] init];
    self.tableView.publeTableDelegate = self;
    
    [self.view addSubview:self.tableView];
    
    
    //加载数据
    [self loadSongList];
    
}

- (void)setUpBackGroundView{
    
    self.backgroudImageView = [FMCreatTool imageViewWithView:self.backgroundView];

    self.backgroudImageView.frame = self.backgroundView.bounds;

    NSURL *imageUrl = [NSURL URLWithString:self.musicModel.pic_300];
    
    [self.backgroudImageView setImageWithURL:imageUrl placeholder:[UIImage imageNamed:@"music_placeholder"]];
    
    if(![self.visualEffectView isDescendantOfView:self.backgroundView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = self.view.bounds;
        [self.backgroundView addSubview:_visualEffectView];
    }

}


#pragma mark - loadData
- (void)loadSongList{
    
   @weakify(self)
    
    [[FMDataManager manager]getSongListWithListid:self.musicModel.listid Success:^(id data) {
        
        @strongify(self)
        
        FMPublicSonglistModel *songList = [FMPublicSonglistModel modelWithJSON:data];
        NSInteger i = 0;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSDictionary *dict in songList.content) {
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            FMPublicSongDetailModel *songDetail = [FMPublicSongDetailModel modelWithJSON:dict];
            songDetail.num = ++i;
            [self.songListArrayM addObject:songDetail];
            [self.songIdsArrayM addObject:songDetail.song_id];
            
        }
        
        @weakify(self)
        
        [GCDQueue executeInMainQueue:^{
            @strongify(self)
            
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), getScreenWidth(), getScreenHeight() - 49 - 64);
            self.headView.frame = CGRectMake(0, 0, getScreenWidth(), getScreenWidth() * 0.5 + 60);
            self.tableView.tableHeaderView = self.headView;
            
            [self.headView setMenuList:songList];
            
            [self.tableView setSongList:_songListArrayM songIds:_songIdsArrayM listKey:_musicModel.listid];
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
        }];

    } failed:^(NSString *message) {
        [GCDQueue executeInMainQueue:^{
            [MBProgressHUD showError:message];
        }];
    }];
    
}

- (void)publickTableClickCell:(FMPublicTableView *)publicTableView{
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    [nav clickMusicCell];
}


#pragma mark - Config TitleView.

- (void)configureTitleView {
    
    BackgroundLineView *lineView = [BackgroundLineView backgroundLineViewWithFrame:CGRectMake(0, 0, self.width, 64)
                                                                         lineWidth:4 lineGap:4
                                                                         lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.015]
                                                                            rotate:M_PI_4];
    [self.titleView addSubview:lineView];
    
    // Title label.
    UILabel *headlinelabel          = [UIView animationsListViewControllerNormalHeadLabel];
    UILabel *animationHeadLineLabel = [UIView animationsListViewControllerHeadLabel];
    
    // Title view.
    UIView *titleView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    [titleView addSubview:headlinelabel];
    [titleView addSubview:animationHeadLineLabel];
    [self.titleView addSubview:titleView];
    
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, self.width, 0.5f)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    [titleView addSubview:line];
    
    // Start glow.
    animationHeadLineLabel.glowRadius            = @(2.f);
    animationHeadLineLabel.glowOpacity           = @(1.f);
    animationHeadLineLabel.glowColor             = [[UIColor colorWithRed:0.203  green:0.598  blue:0.859 alpha:1] colorWithAlphaComponent:0.95f];
    
    animationHeadLineLabel.glowDuration          = @(1.f);
    animationHeadLineLabel.hideDuration          = @(3.f);
    animationHeadLineLabel.glowAnimationDuration = @(2.f);
    
    [animationHeadLineLabel createGlowLayer];
    [animationHeadLineLabel insertGlowLayer];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"explain_icon_blue-return"] forState:UIControlStateNormal];
    [self.titleView addSubview:backButton];
    @weakify(self)
    [backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self popViewControllerAnimated:YES];
    }];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    
    headlinelabel.center          = CGPointMake(titleView.centerX, backButton.centerY);
    animationHeadLineLabel.center = CGPointMake(titleView.centerX, backButton.centerY);
    
    [GCDQueue executeInMainQueue:^{
        
        [animationHeadLineLabel startGlowLoop];
        
    } afterDelaySecs:2.f];
}


- (NSMutableArray *)songListArrayM{
    if (!_songListArrayM) {
        _songListArrayM = [NSMutableArray array];
    }
    return _songListArrayM;
}

- (NSMutableArray *)songIdsArrayM{
    if (!_songIdsArrayM) {
        _songIdsArrayM = [NSMutableArray array];
    }
    return _songIdsArrayM;
}




@end
