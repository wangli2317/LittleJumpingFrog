//
//  FMSongMenuViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMSongMenuViewController.h"
#import "FMPublicMusictablesModel.h"
#import "FMSongMenuCollectionCell.h"
#import "FMSongListViewController.h"

#import "PopAnimator.h"
#import "PushAnimator.h"

@interface FMSongMenuViewController ()<UIViewControllerTransitioningDelegate,
                                       UINavigationControllerDelegate,
                                       UIGestureRecognizerDelegate,
                                       UITableViewDelegate,
                                       UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *songMenuDataArrayM;
@property (nonatomic ,strong) UITableView *songMenuTableView;
@property (nonatomic ,assign) NSInteger songMenuPage;

@end

@implementation FMSongMenuViewController

static NSString *reuseId = @"songMenu";

- (NSMutableArray *)songMenuDataArrayM{
    if (!_songMenuDataArrayM) {
        _songMenuDataArrayM = [NSMutableArray array];
        self.songMenuPage = 1;
         [self loadSongMenuWithPage:self.songMenuPage array:_songMenuDataArrayM reloadView:self.songMenuTableView];
    }
    return _songMenuDataArrayM;
}

#pragma mark - viewAppear - > viewLoad

- (void)setup {
    [super setup];
    
    [self setUpSongMenuTableView];
    [self rootViewControllerSetup];
    [self setUpRefreshFooter];
   
}


- (void)setUpSongMenuTableView{
    self.songMenuTableView                     = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.songMenuTableView.delegate            = self;
    self.songMenuTableView.dataSource          = self;
    self.songMenuTableView.rowHeight           = 250;
    self.songMenuTableView.sectionHeaderHeight = 25.f;
    self.songMenuTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    
    [self.songMenuTableView registerClass:[FMSongMenuCollectionCell class]  forCellReuseIdentifier:@"FMSongMenuTableViewCell"];

    [self.view addSubview:self.songMenuTableView];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.songMenuDataArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FMSongMenuCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMSongMenuTableViewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[FMSongMenuCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FMSongMenuTableViewCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(FMSongMenuCollectionCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell cellOffset];
    
    FMPublicMusictablesModel *musicTable = self.songMenuDataArrayM[indexPath.row];
    
    [cell setSongMenu:musicTable];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FMPublicMusictablesModel *musicModel = self.songMenuDataArrayM[indexPath.row];
    FMSongListViewController *listVC = [[FMSongListViewController alloc] init];
    listVC.musicModel = musicModel;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)setUpRefreshFooter{
    __weak __typeof(self) weakSelf = self;
    self.songMenuTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.songMenuPage += 1;
        [weakSelf loadSongMenuWithPage:self.songMenuPage array:weakSelf.songMenuDataArrayM reloadView:weakSelf.songMenuTableView];
        weakSelf.songMenuTableView.mj_footer.hidden = YES;
    }];
}


#pragma mark - loadData
- (void)loadSongMenuWithPage:(NSInteger)page array:(NSMutableArray *)array reloadView:(UITableView *)view{
    
    [[FMNetManager shareNetManager]netWorkToolGetWithUrl:FMUrl parameters:FMParams(@"method":@"baidu.ting.diy.gedan",@"page_no":[NSString stringWithFormat:@"%ld",page],@"page_size":@"30") response:^(id response) {
        
        for (NSDictionary *dict in response[@"content"]) {
            
            FMPublicMusictablesModel *tables = [FMPublicMusictablesModel modelWithJSON:dict];
            
            [array addObject:tables];
            
            [view reloadData];
        }
    }];
}

#pragma mark - UIScrollView's delegate.

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSArray <FMSongMenuCollectionCell *> *array = [self.songMenuTableView visibleCells];
    
    [array enumerateObjectsUsingBlock:^(FMSongMenuCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj cellOffset];
    }];
}

#pragma mark - RootViewController setup.

- (void)rootViewControllerSetup {
    
    // [IMPORTANT] Enable the Push transitioning.
    self.navigationController.delegate = self;
    
    // [IMPORTANT] Set the RootViewController's push delegate.
    [self useInteractivePopGestureRecognizer];
}

- (void)useInteractivePopGestureRecognizer {
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}



#pragma mark - Push or Pop event.

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        
        return [PushAnimator new];
        
    } else if (operation == UINavigationControllerOperationPop) {
        
        return [PopAnimator new];
        
    } else {
        
        return nil;
    }
}


#pragma mark - Overwrite system methods.

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.enableInteractivePopGestureRecognizer = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //    self.enableInteractivePopGestureRecognizer = YES;
}

@end
