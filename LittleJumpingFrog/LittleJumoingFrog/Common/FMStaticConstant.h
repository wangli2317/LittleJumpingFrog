//
//  FMStaticConstant.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMStaticConstant : NSObject
//version
extern  NSString * const  VERSION;

extern  CGFloat    const  FMCommonSpacing;

extern  CGFloat    const  FMHorizontalSpacing;

extern  CGFloat    const  FMVerticalSpacing;

extern  CGFloat    const  StatusBarHeight;

extern  CGFloat    const  NavigationBarHeight;

extern  CGFloat    const  TabbarHeight;

extern  CGFloat    const  StatusBarAndNavigationBarHeight;

extern  NSString * const  FMUrl;

extern  NSString * const  FMMusic;

extern  NSString * const  DTSNOTIFI_RUNTIME_ERROR;

extern  CGFloat    const  getScreenHeight();

extern  CGFloat    const  getScreenWidth();
@end
