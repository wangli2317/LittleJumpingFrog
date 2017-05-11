//
//  FMRankSongViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/26.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMRankSongViewController.h"
#import "CustomNavigationController.h"

#import "FMRankListModel.h"
#import "FMPublicSongDetailModel.h"
#import "FMRankSonglistModel.h"

#import "FMRankSongListTableHeaderView.h"
#import "FMPublicTableView.h"



@interface FMRankSongViewController ()<FMPublicTableViewDelegate>

@property (nonatomic ,weak  ) UIImageView *backGroundImageView;
@property (nonatomic ,strong) FMPublicTableView *publicTableView;
@property (nonatomic ,strong) FMRankSongListTableHeaderView *headView;
@property (nonatomic ,strong) NSMutableArray *rankArray;
@property (nonatomic ,strong) NSMutableArray *songIds;
@property (nonatomic ,strong) UIVisualEffectView *visualEffectView;
@property (nonatomic ,assign) NSInteger songMenuPage;
@end

@implementation FMRankSongViewController

- (void)setup{
    
    [super setup];
    
    _songMenuPage = 0;
    //背景图片
    [self setUpBackgroundView];
    
    self.headView = [[FMRankSongListTableHeaderView alloc]init];
    
    self.publicTableView = [[FMPublicTableView alloc] init];
    
    self.publicTableView.publeTableDelegate = self;
    
    [self.view addSubview:self.publicTableView];
    
    //加载数据
    [self loadRankDetail];
    
    [self setUpRefreshFooter];
}


- (void)setUpRefreshFooter{
    @weakify(self)
    self.publicTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.songMenuPage += 1;
        [self loadRankDetail];
        self.publicTableView.mj_footer.hidden = YES;
    }];
}

- (void)setUpBackgroundView{

    self.backGroundImageView = [FMCreatTool imageViewWithView:self.backgroundView];
    
    self.backGroundImageView.frame = self.backgroundView.bounds;
    
    NSURL *imageUrl = [NSURL URLWithString:self.rankType.pic_s444];
    
    [self.backGroundImageView setImageWithURL:imageUrl placeholder:[UIImage imageNamed:@"music_placeholder"]];
    
    if(![self.visualEffectView isDescendantOfView:self.backgroundView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.visualEffectView.frame = self.view.bounds;
        [self.backgroundView addSubview:_visualEffectView];
    }
    

}

#pragma mark - loadData
- (void)loadRankDetail{
 
    NSInteger offset = _songMenuPage * 30;
    
    @weakify(self)
    
    [[FMDataManager manager] getRankSongListWithOffset:offset type:self.rankType.type Success:^(id data) {
        
        @strongify(self)
        
        NSArray *songList = data[@"song_list"];
        NSInteger i = offset;
        
        FMRankSonglistModel *rankSongListModel = [FMRankSonglistModel modelWithJSON:data[@"billboard"]];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSDictionary *dict in songList) {
            
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            FMPublicSongDetailModel *songDetail = [FMPublicSongDetailModel modelWithJSON:dict];
            songDetail.num = ++i;
            [self.rankArray addObject:songDetail];
            [self.songIds addObject:songDetail.song_id];
            
        }
        
        
        [GCDQueue executeInMainQueue:^{
            
            self.publicTableView.frame = CGRectMake(0,0, getScreenWidth(), getScreenHeight());
            
            self.headView.frame =CGRectMake(0, 0, getScreenWidth(), getScreenWidth() * 0.5 + 60);
            
            self.publicTableView.tableHeaderView = self.headView;
            
            self.headView.songListModel = rankSongListModel;
            
            [self.publicTableView setSongList:_rankArray songIds:_songIds listKey:_rankType.comment];
            
            [self.publicTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            
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


- (NSMutableArray *)rankArray{
    if (!_rankArray) {
        _rankArray = [NSMutableArray array];
    }
    return _rankArray;
}

- (NSMutableArray *)songIds{
    if (!_songIds) {
        _songIds = [NSMutableArray array];
    }
    return _songIds;
}



@end
