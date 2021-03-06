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
#import "FMCircleView.h"

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
    FMPublicTableViewCell *cell         = [FMPublicTableViewCell publicTableViewCellcellWithTableView:tableView];
    cell.backgroundColor                = [UIColor clearColor];
    cell.menuButton.tag                 = indexPath.row;
    cell.detailModel                    = songDetail;
    cell.delegate                       = self;
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

- (void)clickCellMenuItemAtIndex:(NSInteger)cellIndex Cell:(FMPublicTableViewCell *)cell{
    // 点击后自动关闭
    self.isOpenCell = nil;
    [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    self.opendCellIndex = nil;
    
    switch (cellIndex) {
        case FavoriteItem:
            NSLog(@"点击了收藏");
            [FMPromptTool promptModeText:@"已收藏" afterDelay:1];
            break;
        case AlbumItem:
            NSLog(@"点击了专辑");
            [FMPromptTool promptModeText:@"暂无专辑信息" afterDelay:1];
            break;
        case DownLoadItem:{
            NSLog(@"点击了下载");
            
            FMPublicSongDetailModel *songDetail = cell.detailModel;
            
            NSInteger index = [self.songListArrayM indexOfObject:songDetail];
            
            @weakify(self)
            
            [[FMDataManager manager]getPublicListWithSongId:songDetail.song_id Success:^(FMMusicModel * musicEntity) {
                
                 @strongify(self)
                
                if (!musicEntity.fileSongLink || [musicEntity.fileSongLink isEqualToString:@""]) {
                    
                    [self.musicEntityArray setObject:musicEntity atIndexedSubscript:index];
                    
                    CGFloat radius     = 80;
                    
                    CGPoint point2     = self.center;
                    
                    FMCircleView *circleView = [FMCircleView circleViewWithFrame:CGRectMake(0, 0, radius, radius) lineWidth:radius / 2.f lineColor:[UIColor blueColor]
                                                               clockWise:YES startAngle:0];
                    circleView.center = point2;
                    
                    UIView *view = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
                    view.backgroundColor = UIColorFromRGBALPHA(0x000000, 0.7);
                    [[UIApplication sharedApplication].keyWindow addSubview:view];
                    [view addSubview:circleView];
                    
                    [[FMDataManager manager]downLoadMp3WithUrl:musicEntity.songLink Success:^(id data) {
                        
                        musicEntity.fileSongLink = data;
                        [musicEntity save];
                        
                        [GCDQueue executeInMainQueue:^{
                            [view removeFromSuperview];
                            [FMPromptTool promptModeText:@"下载完成" afterDelay:1];
                        }];
                    } failed:^(NSString *message) {
                        
                        [GCDQueue executeInMainQueue:^{
                            [view removeFromSuperview];
                            [FMPromptTool promptModeText:@"下载失败" afterDelay:1];
                        }];
                        
                    } progress:^(CGFloat progress) {
                        NSLog(@"%f",progress);
                        //进行动画
                        [GCDQueue executeInMainQueue:^{
                             [circleView strokeEnd:progress  animationType:ExponentialEaseInOut animated:YES duration:1.f];
                        }];
                    }];

                }else{
                    
                    [GCDQueue executeInMainQueue:^{
                        [FMPromptTool promptModeText:@"您已经下载过当前歌曲" afterDelay:1];
                    }];
                    
                }
            } failed:^(NSString *message) {
                [GCDQueue executeInMainQueue:^{
                    [MBProgressHUD showError:message];
                }];
            }];
        
            
        }break;
        case SingerOperation:
            NSLog(@"点击了歌手");
            [FMPromptTool promptModeText:@"暂无歌手信息" afterDelay:1];
            break;
        case DeleteItem:{
            NSLog(@"点击了删除");
            
            FMPublicSongDetailModel *songDetail = cell.detailModel;
            
            [[FMDataManager manager]deleteMusicModelAndMp3WithSongID:songDetail.song_id Success:^(NSString *message) {
               
                 [FMPromptTool promptModeText:message afterDelay:1];
                
            } failed:^(NSString *message) {
                
                 [FMPromptTool promptModeText:message afterDelay:1];
            }];

            
        }break;
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
    
        @weakify(self)
        
        [[FMDataManager manager]getPublicListWithSongId:_songIdsArrayM[index] Success:^(FMMusicModel * musicEntity) {
            
            @strongify(self)

            [self.musicEntityArray setObject:musicEntity atIndexedSubscript:index];
            
            [self updateIndicatorPresentMusicViewControllerWithIndexPath:indexPath musicEntity:musicEntity];
            
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
    
    @weakify(self)
    
    [[FMDataManager manager]getPublicListWithSongId:_songIdsArrayM[currentIndex] Success:^(FMMusicModel *musicEntity) {
        
         @strongify(self)
        
        [self.musicEntityArray setObject:musicEntity atIndexedSubscript:currentIndex];
        
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
