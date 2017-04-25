//
//  FMPublicTableView.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPublicTableView.h"
#import "FMPublicTableViewCell.h"
#import "FMMusicIndicator.h"
#import <NAKPlaybackIndicatorView.h>
#import "FMMusicModel.h"
#import "FMPublicSongDetailModel.h"
#import "FMPublicSonglistModel.h"
#import "FMMusicViewController.h"


typedef NS_ENUM(NSInteger) {
    FavoriteItem = 0,
    AlbumItem,
    DownLoadItem,
    SingerOperation,
    DeleteItem
}item;

@interface FMPublicTableView ()<UITableViewDelegate,
                                UITableViewDataSource,
                                PublicTableViewCellDelegate,
                                FMMusicViewControllerDelegate>

@property (nonatomic ,weak  ) FMPublicTableViewCell *isOpenCell;
@property (nonatomic ,assign) NSIndexPath *opendCellIndex;
@property (nonatomic ,assign) BOOL isOpen;

@property (nonatomic ,copy  ) NSString *listKey;
@property (nonatomic ,copy  ) NSArray *songListArrayM;
@property (nonatomic ,copy  ) NSArray *songIdsArrayM;
@property (nonatomic ,strong) NSMutableArray *musicEntityArray;
@end

@implementation FMPublicTableView

- (void)setSongList:(NSArray *)list songIds:(NSArray *)ids listKey:(NSString *)listKey{
    self.songListArrayM = list;
    self.listKey = listKey;
    self.songIdsArrayM = ids;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.songListArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMPublicSongDetailModel *songDetail = self.songListArrayM[indexPath.row];
    FMPublicTableViewCell *cell = [FMPublicTableViewCell publicTableViewCellcellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.menuButton.tag = indexPath.row;
    cell.detailModel = songDetail;
    cell.delegate = self;
    [self updatePlaybackIndicatorOfCell:cell];
    [cell setUpCellMenu];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.isOpen = self.isOpenCell && self.isOpenCell.isOpenMenu && (self.opendCellIndex.row == indexPath.row);
    if (self.isOpen) {
        return 100;
    }
    else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadTableCellData:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, getScreenWidth(), 10)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectio{
    return 50;
}



#pragma mark - cellDelegate
- (void)clickButton:(UIButton *)button openMenuOfCell:(FMPublicTableViewCell *)cell{
    NSIndexPath *openIndex = [NSIndexPath indexPathForRow:button.tag inSection:0];
    if (self.isOpen) {
        self.isOpenCell = nil;//close
        [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        self.opendCellIndex = nil;
    }
    else{
        self.isOpenCell = cell;
        self.opendCellIndex = openIndex;
        [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self scrollToRowAtIndexPath:self.opendCellIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)clickCellMenuItemAtIndex:(NSInteger)index Cell:(FMPublicTableViewCell *)cell{
    // 点击后自动关闭
    self.isOpenCell = nil;
    [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    self.opendCellIndex = nil;
    
    switch (index) {
        case FavoriteItem:
            NSLog(@"点击了收藏");
            [FMPromptTool promptModeText:@"已收藏" afterDelay:1];
            break;
        case AlbumItem:
            NSLog(@"点击了专辑");
            [FMPromptTool promptModeText:@"暂无专辑信息" afterDelay:1];
            break;
        case DownLoadItem:
            NSLog(@"点击了下载");
            [FMPromptTool promptModeText:@"暂时无法下载" afterDelay:1];
            break;
        case SingerOperation:
            NSLog(@"点击了歌手");
            [FMPromptTool promptModeText:@"暂无歌手信息" afterDelay:1];
            break;
        case DeleteItem:
            NSLog(@"点击了删除");
            [FMPromptTool promptModeText:@"无法删除网络资源" afterDelay:1];
            break;
    }
}

- (void)clickIndicatorView{
//    [[FMPlayingViewController sharePlayingVC] clickIndicator];
}

#pragma mark - update indicatorView state
- (void)updateIndicatorViewWithIndexPath:(NSIndexPath *)indexPath {
    
    for (FMPublicTableViewCell *cell in self.visibleCells) {
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
    }
    FMPublicTableViewCell *musicsCell = [self cellForRowAtIndexPath:indexPath];
    musicsCell.indicatorViewState = NAKPlaybackIndicatorViewStatePlaying;
}


- (void)updatePlaybackIndicatorOfCell:(FMPublicTableViewCell *)cell {
    
    FMPublicSongDetailModel *detailModel = cell.detailModel;

    if (detailModel.song_id == [[FMMusicViewController sharedInstance] currentPlayingMusic].songId) {
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
        cell.indicatorViewState = [FMMusicIndicator shareIndicator].state;
    } else {
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
    }
}

#pragma mark - loadTableCellData
- (void)loadTableCellData:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    
    if ([[self.musicEntityArray objectAtIndex:index] isKindOfClass:[FMMusicModel class]]) {
        
        FMMusicModel *musicEntity = [self.musicEntityArray objectAtIndex:index];
        
        [self updateIndicatorPresentMusicViewControllerWithIndexPath:indexPath musicEntity:musicEntity];
        
    }else{
    
        __weak typeof(self) weakSelf = self;
        
        [[FMDataManager manager]getPublicListWithSongId:_songIdsArrayM[index] Success:^(FMMusicModel * musicEntity) {
            
             __strong typeof(weakSelf)strongSelf = weakSelf;

            [strongSelf.musicEntityArray setObject:musicEntity atIndexedSubscript:index];
            
            [strongSelf updateIndicatorPresentMusicViewControllerWithIndexPath:indexPath musicEntity:musicEntity];
            
        } failed:^(NSString *message) {
            [GCDQueue executeInMainQueue:^{
                [MBProgressHUD showError:message];
            }];
        }];
    
    }
}

- (void)updateIndicatorPresentMusicViewControllerWithIndexPath:(NSIndexPath *)indexPath musicEntity:(FMMusicModel *)musicEntity{
    
     __weak typeof(self) weakSelf = self;
    
    FMMusicViewController *musicVC = [FMMusicViewController sharedInstance];
    
    musicVC.delegate = weakSelf;
    
    musicVC.specialIndex = indexPath.row;
    
    musicVC.musicEntities = weakSelf.musicEntityArray;
    
    [weakSelf updateIndicatorViewWithIndexPath:indexPath];
    [weakSelf deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([weakSelf.publeTableDelegate respondsToSelector:@selector(publickTableClickCell:)]) {
        [weakSelf.publeTableDelegate publickTableClickCell:self];
    }

}

#pragma mark - FMMusicViewControllerDelegate
- (void)updatePlaybackIndicatorOfVisisbleCells{
    for (FMPublicTableViewCell *cell in self.visibleCells) {
        [self updatePlaybackIndicatorOfCell:cell];
    }
}

- (void)playMusicCellDataWithCurrentIndex:(NSInteger)currentIndex setupMusicEntity:(void (^)())setupMusicEntity{
    
    __weak typeof(self) weakSelf = self;
    
    [[FMDataManager manager]getPublicListWithSongId:_songIdsArrayM[currentIndex] Success:^(FMMusicModel *musicEntity) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf.musicEntityArray setObject:musicEntity atIndexedSubscript:currentIndex];
        
        setupMusicEntity();
        
    } failed:^(NSString *message) {
        [GCDQueue executeInMainQueue:^{
            [MBProgressHUD showError:message];
        }];
    }];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)musicEntityArray{
    if (!_musicEntityArray) {
        _musicEntityArray = [NSMutableArray arrayWithArray:_songIdsArrayM];
    }
    return _musicEntityArray;
}

@end
