//
//  PZRefreshNormalControl.h
//  mogi
//
//  Created by cherry on 16/1/13.
//  Copyright © 2016年 com.8w4q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZRefreshNormalControl : UIView <UIScrollViewDelegate>

/**
 *  This function simply calls attachToScrollView. Kept for
 *  compatibility with earlier versions.
 */
+ (PZRefreshNormalControl*)attachToTableView:(UITableView*)tableView
                     withRefreshTarget:(id)refreshTarget
                      andRefreshAction:(SEL)refreshAction;

/**
 *  Call this function to attach a pong refresh control to
 *  a UIScrollView. Keep in mind that it does this by adding
 *  the pong refresh control as a subview above the normal
 *  content frame (negative y value in the origin), so if you
 *  have content up there, it'll be covered up.
 *
 *  The pong refresh control will perform the refreshAction on
 *  on the refreshTarget when the user triggers a refresh.
 */
+ (PZRefreshNormalControl*)attachToScrollView:(UIScrollView*)scrollView
                      withRefreshTarget:(id)refreshTarget
                       andRefreshAction:(SEL)refreshAction
                             styleClass:(Class)styleClass;

#pragma mark - Functions required to use a pong refresh control

/**
 * Calls [self beginLoadingAnimated:YES]. Kept for
 * backwards-compatibility.
 */
- (void)beginLoading;

/**
 * Call this function to programatically scroll the refresh
 * control into view, and begin the animation. Does not notify
 * target of trigger.
 * @param animated Dictates whether the action of scrolling to
 * the refresh control is animated (YES) or instant (NO).
 */
- (void)beginLoadingAnimated:(BOOL)animated;

/**
 *  Call this function when whatever loading task you're doing
 *  is done. This will reset the pong refresh control and hide
 *  it. It's also a good idea to call this if your view is
 *  going to disappear.
 */
- (void)finishedLoading;

/**
 *  Override the implementation of scrollViewDidScroll: in
 *  UIScrollViewDelegate and call this function inside of it.
 *  This lets the pong refresh control know to update its
 *  subviews as the user scrolls.
 */
- (void)scrollViewDidScroll;

/**
 *  Override the implementation of scrollViewDidEndDragging:willDecelerate:
 *  in UIScrollViewDelegate and call this function inside of it.
 *  This lets the pong refresh control know the user let go
 *  of the scroll view and causes it to check if a refresh should
 *  be triggered.
 */
- (void)scrollViewDidEndDragging;


@end

