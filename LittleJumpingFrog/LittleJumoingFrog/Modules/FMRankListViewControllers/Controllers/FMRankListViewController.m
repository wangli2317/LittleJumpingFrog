//
//  FMRankListViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMRankListViewController.h"
#import "FMRankSongViewController.h"

#import "FMRankListCell.h"
#import "FMRankListHeaderView.h"

#import "FMRankListModel.h"


@interface FMRankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *rankListArray;

@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation FMRankListViewController

- (void)setup{
    
    [super setup];
        
    self.tableView                   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.tableView.delegate          = self;
    self.tableView.dataSource        = self;
    self.tableView.backgroundColor   = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;

    FMRankListHeaderView *headerView = [FMRankListHeaderView new];

    self.tableView.tableHeaderView   = headerView;
    
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rankListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMRankListModel *list = self.rankListArray[indexPath.row];
    FMRankListCell *cell = [FMRankListCell rankCellWithTableView:tableView songInfoArray:list.content];
    cell.rankListImage = list.pic_s260;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = getScreenWidth() / 3;
    return height + 2 * FMVerticalSpacing;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FMRankListModel *list = self.rankListArray[indexPath.row];
    FMRankSongViewController *vc = [[FMRankSongViewController alloc] init];
    vc.rankType = list;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loadData
- (void)loadRankData{
    
    @weakify(self)
    [[FMDataManager manager] getRankListSuccess:^(id data) {
        
        @strongify(self)
        
        self.rankListArray = data;
        
        [GCDQueue executeInMainQueue:^{
            [self.tableView reloadData];
        }];
    
    } failed:^(NSString *message) {
        [GCDQueue executeInMainQueue:^{
            [MBProgressHUD showError:message];
        }];
    }];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)rankListArray{
    if (!_rankListArray) {
        _rankListArray = [NSMutableArray array];
        [self loadRankData];
    }
    return _rankListArray;
}

@end
