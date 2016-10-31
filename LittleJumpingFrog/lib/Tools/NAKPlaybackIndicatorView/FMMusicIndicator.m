//
//  FMMusicIndicator.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMMusicIndicator.h"

@implementation FMMusicIndicator
static id _indicator;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _indicator = [super allocWithZone:zone];
    });
    return _indicator;
}

+ (instancetype)shareIndicator{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _indicator = [[self alloc] initWithFrame:CGRectMake(getScreenWidth() - 44, 0, 44, 44)];
    });
    return _indicator;
}

@end
