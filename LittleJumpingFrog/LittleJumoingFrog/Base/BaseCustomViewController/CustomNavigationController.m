//
//  CustomNavigationController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/5.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "CustomNavigationController.h"
#import "FMMusicIndicator.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"

#import "FMMusicViewController.h"

@interface CustomNavigationController ()<UIViewControllerTransitioningDelegate>

@end

@implementation CustomNavigationController

- (instancetype)initWithRootViewController:(CustomViewController *)rootViewController setNavigationBarHidden:(BOOL)hidden {
    
    CustomNavigationController *ncController = [[[self class] alloc] initWithRootViewController:rootViewController];
    [ncController setNavigationBarHidden:hidden animated:NO];
    [rootViewController useInteractivePopGestureRecognizer];
    
    return ncController;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpMusicIndicator];
}

- (void)setUpMusicIndicator{
    FMMusicIndicator *indicator = [FMMusicIndicator shareIndicator];
    indicator.hidesWhenStopped = NO;
    indicator.tintColor = FMMainColor;
    if (indicator.state != NAKPlaybackIndicatorViewStatePlaying) {
        indicator.state = NAKPlaybackIndicatorViewStatePaused;
    } else {
        indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMusicIndicator)];
    [indicator addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationBar addSubview:indicator];
}

- (void)clickMusicIndicator{
    
    FMMusicViewController *musicVC = [FMMusicViewController sharedInstance];
    if (!musicVC.musicEntities.count) {
        [FMPromptTool promptModeText:@"没有正在播放的歌曲" afterDelay:1.0];
    }else{
    
        if (musicVC.musicEntities.count>1) {
            musicVC.dontReloadMusic = YES;
        }
        [self presentMusicViewController:musicVC];
    }
}

- (void)clickMusicCell{
    FMMusicViewController *musicVC = [FMMusicViewController sharedInstance];
    [self presentMusicViewController:musicVC];
}

- (void)presentMusicViewController:(FMMusicViewController *)MusicVC{
    MusicVC.transitioningDelegate  = self;
    MusicVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:MusicVC animated:YES completion:nil];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 如果push进来的不是第一个控制器
    if (self.childViewControllers.count > 0) {
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 定制转场动画

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    
    return [PresentingAnimator new];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [DismissingAnimator new];
}
@end
