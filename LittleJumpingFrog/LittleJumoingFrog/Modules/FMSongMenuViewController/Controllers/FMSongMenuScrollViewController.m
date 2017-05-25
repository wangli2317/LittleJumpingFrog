//
//  FMSongMenuScrollViewController.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 2017/5/25.
//  Copyright © 2017年 WangGang. All rights reserved.
//

#import "FMSongMenuScrollViewController.h"
#import "FMSongListViewController.h"

#import "FMScrollViewManager.h"

#import "PopAnimator.h"
#import "PushAnimator.h"

#import "FMPublicMusictablesModel.h"

#import "BackgroundLineView.h"

#import "UIView+AnimationsListViewController.h"
#import "UIView+GlowView.h"

@interface FMSongMenuScrollViewController ()<FMScrollViewManagerDelegate,
                                             UINavigationControllerDelegate,
                                             UIGestureRecognizerDelegate>

@property (nonatomic, strong) FMScrollViewManager *scrollViewManager;

@end

@implementation FMSongMenuScrollViewController

- (void)setup {
    
    [super setup];
    
    [self rootViewControllerSetup];
    
    [self configureTitleView];
    
    [self addNotificaton];
    
    self.scrollViewManager = [[FMScrollViewManager alloc] initWithDataMethod:@"fetchSongMenuByPage:otherParams:success:failed:"
                                                                       frame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49 - 64)
                                                                 andDelegate:self
                                                            defaultClassType:@"FMSongMenuScrollViewCell"
                                                                 columnWidth:2.0f
                                                                      startY:0
                                                              leftMarginCols:0
                                                                 otherParams:nil
                                                        needPzRefreshControl:YES];
    //start Load
    [self.scrollViewManager startLoad];
    
    
    
}

- (void) addHeader{
    
}

- (void) beforeAddScrollView{
   
}
- (void) afterAddScrollView{
    
}
- (void) afterReloadScrollView{

}
- (UIView*) getParentView{
    return self.view;
}

- (void) buttonClicked:(id)sender cell:(FMScrollViewCell *) cell{
    
}

-(void)cellClicked:(FMScrollViewCell *)cell{
    
    FMPublicMusictablesModel *musicModel = cell.object;

    FMSongListViewController *listVC     = [[FMSongListViewController alloc] init];

    listVC.musicModel                    = musicModel;

    [self.navigationController pushViewController:listVC animated:YES];
    
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

#pragma mark - Config TitleView.

- (void)configureTitleView {
    
    BackgroundLineView *lineView = [BackgroundLineView backgroundLineViewWithFrame:CGRectMake(0, 0, self.width, 64)
                                                                         lineWidth:4 lineGap:4
                                                                         lineColor:[[UIColor blackColor] colorWithAlphaComponent:0.015]
                                                                            rotate:M_PI_4];
    [self.titleView addSubview:lineView];
    
    // Title label.
    UILabel *headlinelabel          = [UIView animationsListViewControllerNormalHeadLabel];
    UILabel *animationHeadLineLabel = [UIView animationsListViewControllerHeadLabel];
    
    // Title view.
    UIView *titleView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    headlinelabel.center          = titleView.middlePoint;
    animationHeadLineLabel.center = titleView.middlePoint;
    
    headlinelabel.bottom          = titleView.bottom;
    animationHeadLineLabel.bottom = titleView.bottom;
    
    [titleView addSubview:headlinelabel];
    [titleView addSubview:animationHeadLineLabel];
    [self.titleView addSubview:titleView];
    
    UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, self.width, 0.5f)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    [titleView addSubview:line];
    
    // Start glow.
    animationHeadLineLabel.glowRadius            = @(2.f);
    animationHeadLineLabel.glowOpacity           = @(1.f);
    animationHeadLineLabel.glowColor             = [[UIColor colorWithRed:0.203  green:0.598  blue:0.859 alpha:1] colorWithAlphaComponent:0.95f];
    
    animationHeadLineLabel.glowDuration          = @(1.f);
    animationHeadLineLabel.hideDuration          = @(3.f);
    animationHeadLineLabel.glowAnimationDuration = @(2.f);
    
    [animationHeadLineLabel createGlowLayer];
    [animationHeadLineLabel insertGlowLayer];
    
    [GCDQueue executeInMainQueue:^{
        
        [animationHeadLineLabel startGlowLoop];
        
    } afterDelaySecs:2.f];
}

#pragma mark - Add Notification

- (void)addNotificaton{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollViewDidScroll:) name:@"FMScrollViewDidScroll" object:nil];
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


- (void)scrollViewDidScroll:(NSNotification *)notification{
    
    FMScrollView *scrollView = notification.object;
    

}
@end
