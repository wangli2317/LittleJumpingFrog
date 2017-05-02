//
//  FMStaticConstant.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMStaticConstant.h"

@implementation FMStaticConstant
//version number
NSString * const VERSION                       = @"3.0";

CGFloat const FMCommonSpacing                  = 10;

CGFloat const FMHorizontalSpacing              = 20;

CGFloat const FMVerticalSpacing                = 5;

CGFloat const  StatusBarHeight                 = 20.f;

CGFloat const  NavigationBarHeight             = 44.f;

CGFloat const  TabbarHeight                    = 49.f;

CGFloat const  StatusBarAndNavigationBarHeight = (20.f + 44.f);

NSString * const  FMUrl                        = @"http://tingapi.ting.baidu.com/v1/restserver/ting";

NSString * const  FMMusic                      = @"http://ting.baidu.com/data/music/links";

NSString * const  DTSNOTIFI_RUNTIME_ERROR      = @"DTSNOTIFI_RUNTIME_ERROR";

CGFloat  const getScreenHeight (){
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat  const getScreenWidth (){
    return [UIScreen mainScreen].bounds.size.width;
}
@end
