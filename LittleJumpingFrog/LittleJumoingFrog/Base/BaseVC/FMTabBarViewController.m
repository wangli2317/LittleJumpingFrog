//
//  ViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMTabBarViewController.h"
#import "CustomNavigationController.h"

@interface FMTabBarViewController ()<UITabBarDelegate>
@end

@implementation FMTabBarViewController

- (void)setup{
    [super setup];
    
}

- (NSArray<CustomViewController *> *)viewControllers{
    
    static NSMutableArray *_viewControllers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _viewControllers = [NSMutableArray array];
        
         CustomViewController * SongMenuVC         = [[DTSViewManager manager]getInstanceFromName:@"FMSongMenuViewController"];

         CustomNavigationController *SongMenuNav   = [[CustomNavigationController alloc]initWithRootViewController:SongMenuVC
                                                                                          setNavigationBarHidden:YES];

         CustomViewController * localMusicVC       = [[DTSViewManager manager]getInstanceFromName:@"FMLocalMusicViewController"];

         CustomNavigationController *localMusicNav = [[CustomNavigationController alloc]initWithRootViewController:localMusicVC
                                                                                            setNavigationBarHidden:YES];

         CustomViewController * searchVC           = [[DTSViewManager manager]getInstanceFromName:@"FMSearchViewController"];

         CustomNavigationController *searchNav     = [[CustomNavigationController alloc]initWithRootViewController:searchVC
                                                                                        setNavigationBarHidden:YES];

         CustomViewController * myViewController   = [[DTSViewManager manager]getInstanceFromName:@"FMRankListViewController"];

         CustomNavigationController *myNav         = [[CustomNavigationController alloc]initWithRootViewController:myViewController
                                                                                    setNavigationBarHidden:YES];
        
        [_viewControllers addObjectsFromArray:@[SongMenuNav,localMusicNav,searchNav,myNav]];
    });
    
    return _viewControllers;
}

- (void)buildItems{
    [super buildItems];
    
    UITabBarItem *SongMenuVCItem       = [[UITabBarItem alloc]initWithTitle:@"歌单"
                                                                      image:[UIImage imageNamed:@"songList_normal"]
                                                              selectedImage:[UIImage imageNamed:@"songList_highLighted"]];
    
    UITabBarItem *localMusicVCItem     = [[UITabBarItem alloc]initWithTitle:@"本地"
                                                                      image:[UIImage imageNamed:@"songNewList_normal"]
                                                              selectedImage:[UIImage imageNamed:@"songNewList_highLighted"]];
    
    UITabBarItem *searchVCItem         = [[UITabBarItem alloc]initWithTitle:@"搜索"
                                                                      image:[UIImage imageNamed:@"songSearch_normal"]
                                                              selectedImage:[UIImage imageNamed:@"songSearch_highLighted"]];
    
    UITabBarItem *myViewControllerItem = [[UITabBarItem alloc]initWithTitle:@"排行"
                                                                      image:[UIImage imageNamed:@"songRank_normal"]
                                                              selectedImage:[UIImage imageNamed:@"songRank_highLighted"]];
    

    UITabBar *tabbar                   = [[UITabBar alloc]initWithFrame:self.tabBarView.bounds];
    tabbar.delegate                    = self;
    tabbar.items                       = @[SongMenuVCItem,localMusicVCItem,searchVCItem,myViewControllerItem];

    [self.tabBarView addSubview:tabbar];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [tabBar.items indexOfObject:item];
    [self didSelectedIndex:index];
}

@end
