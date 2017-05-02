//
//  PZRefreshControlStyle.h
//  PullToRefreshControlDemo
//
//  Created by cherry on 16/1/12.
//  Copyright © 2016年 onightjar.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PZRefreshControlStyle <NSObject>

+ (UIColor *)ptrLayerColor;
+ (UIColor *)loadingLayerColor;
+ (UIColor *)tipColor;
+ (UIColor *)keywordColor;


+ (UIFont *)keywordFont;
+ (UIFont *)tipFont;

+ (NSArray *)tipsArray;
+ (NSArray *)keywordArray;


@end