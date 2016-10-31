//
//  ViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMTabBarViewController.h"
#import "CustomNavigationController.h"
//#import "FMTabBar.h"

@interface FMTabBarViewController ()/**<FMTabBarDelegate>*/

//@property (nonatomic,strong)NSMutableArray  <UITabBarItem *> * mTabbarItemArray;

@end

@implementation FMTabBarViewController

//@synthesize viewControllers = _viewControllers;
//
//- (NSArray<CustomViewController *> *)viewControllers{
//    
//    if (!_viewControllers) {
//        // 添加所有子控制器
//        _viewControllers = [self setUpAllChildViewController];
//    }
//    return _viewControllers;
//}

//- (NSMutableArray *)mTabbarItemArray{
//    if (!_mTabbarItemArray) {
//        _mTabbarItemArray = [NSMutableArray array];
//    }
//    return _mTabbarItemArray;
//}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpAllChildViewController];
    }
    return self;
}


- (NSArray *)setUpAllChildViewController{
    // 1

    NSMutableArray *mViewControllerArray = [NSMutableArray array];
    
    CustomViewController * SongMenuVC = [NSClassFromString(@"FMSongMenuViewController") new];
    
   [mViewControllerArray addObject:[self setUpOneChildViewController:SongMenuVC image:[UIImage imageNamed:@"songList_normal"] selectedImage:[UIImage imageNamed:@"songList_highLighted"] title:@"歌单"]];
    
    // 2xxxxxxxxx
    CustomViewController * localMusicVC = [NSClassFromString(@"FMLocalMusicViewController") new];
    [mViewControllerArray addObject:[self setUpOneChildViewController:localMusicVC image:[UIImage imageNamed:@"songNewList_normal"] selectedImage:[UIImage imageNamed:@"songNewList_highLighted"] title:@"本地"]];
    
    // 3
    CustomViewController *searchVC =  [NSClassFromString(@"FMSearchViewController") new];;
    [mViewControllerArray addObject:[self setUpOneChildViewController:searchVC image:[UIImage imageNamed:@"songSearch_normal"] selectedImage:[UIImage imageNamed:@"songSearch_highLighted"] title:@"搜索"]];
    
    // 4
    CustomViewController * myViewController = [NSClassFromString(@"FMRankListViewController") new];
    [mViewControllerArray addObject:[self setUpOneChildViewController:myViewController image:[UIImage imageNamed:@"songRank_normal"] selectedImage:[UIImage imageNamed:@"songRank_highLighted"] title:@"排行"]];
    
    return [mViewControllerArray copy];
}

- (CustomNavigationController *)setUpOneChildViewController:(CustomViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
  
    // 保存tabBarItem模型到数组
//    [self.mTabbarItemArray addObject:vc.tabBarItem];
    
    CustomNavigationController *nav = [[CustomNavigationController alloc]initWithRootViewController:vc setNavigationBarHidden:NO];
    
    nav.title = title;
    
    [self addChildViewController:nav];
    return nav;
}

//- (void)buildItems{
//
//    FMTabBar *tabBar = [[FMTabBar alloc] initWithFrame:self.tabBarView.bounds];
//    tabBar.backgroundColor = [UIColor whiteColor];
//    tabBar.delegate = self;
//    tabBar.items = self.mTabbarItemArray;
//    [self.tabBarView  addSubview: tabBar];
//
//}

//#pragma mark - 当点击tabBar上的按钮调用
//- (void)tabBar:(FMTabBar *)tabBar didClickButton:(NSInteger)index{
//    [self didSelectedIndex:index];
//}



@end
