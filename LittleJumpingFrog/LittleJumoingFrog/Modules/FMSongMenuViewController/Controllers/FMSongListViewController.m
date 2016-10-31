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
    
    [[FMNetManager shareNetManager]netWorkToolGetWithUrl:FMUrl parameters:FMParams(@"method":@"baidu.ting.diy.gedanInfo",@"listid":self.musicModel.listid) response:^(id response) {
        
        FMPublicSonglistModel *songList = [FMPublicSonglistModel modelWithJSON:response];
        NSInteger i = 0;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSDictionary *dict in songList.content) {
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            FMPublicSongDetailModel *songDetail = [FMPublicSongDetailModel modelWithJSON:dict];
            songDetail.num = ++i;
            [weakSelf.songListArrayM addObject:songDetail];
            [weakSelf.songIdsArrayM addObject:songDetail.song_id];
            
        }

        
        [GCDQueue executeInMainQueue:^{

            
            weakSelf.tableView.frame = CGRectMake(0,40, getScreenWidth(), getScreenHeight());
            weakSelf.headView.frame = CGRectMake(0, 0, getScreenWidth(), getScreenWidth() * 0.5 + 60);
               weakSelf.tableView.tableHeaderView = weakSelf.headView;
            
            [weakSelf.headView setMenuList:songList];

            [weakSelf.tableView setSongList:_songListArrayM songIds:_songIdsArrayM listKey:_musicModel.listid];
            
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

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
