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

#import "FMPublicSonglistModel.h"
#import "FMPublicMusictablesModel.h"
#import "FMPublicSongDetailModel.h"

#import "UIView+Animations.h"

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
    
    __weak typeof(self) weakSelf = self;
    
    [[FMDataManager manager]getSongListWithListid:self.musicModel.listid Success:^(id data) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        FMPublicSonglistModel *songList = [FMPublicSonglistModel modelWithJSON:data];
        NSInteger i = 0;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSDictionary *dict in songList.content) {
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            FMPublicSongDetailModel *songDetail = [FMPublicSongDetailModel modelWithJSON:dict];
            songDetail.num = ++i;
            [strongSelf.songListArrayM addObject:songDetail];
            [strongSelf.songIdsArrayM addObject:songDetail.song_id];
            
        }
        
        
        [GCDQueue executeInMainQueue:^{
            
            
            strongSelf.tableView.frame = CGRectMake(0,0, getScreenWidth(), getScreenHeight());
            strongSelf.headView.frame = CGRectMake(0, 0, getScreenWidth(), getScreenWidth() * 0.5 + 60);
            strongSelf.tableView.tableHeaderView = strongSelf.headView;
            
            [strongSelf.headView setMenuList:songList];
            
            [strongSelf.tableView setSongList:_songListArrayM songIds:_songIdsArrayM listKey:_musicModel.listid];
            
            [strongSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
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
