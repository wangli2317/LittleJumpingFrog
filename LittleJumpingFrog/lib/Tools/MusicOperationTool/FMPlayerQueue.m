//
//  FMPlayerQueue.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPlayerQueue.h"

@implementation FMPlayerQueue

static id _playerQueue;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerQueue = [super allocWithZone:zone];
    });
    return _playerQueue;
}

+ (instancetype)sharePlayerQueue{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerQueue = [[self alloc] init];
    });
    return _playerQueue;
}

@end
