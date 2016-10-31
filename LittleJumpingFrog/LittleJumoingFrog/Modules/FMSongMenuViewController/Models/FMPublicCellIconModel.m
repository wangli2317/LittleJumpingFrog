//
//  FMPublicCellIconModel.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPublicCellIconModel.h"

@implementation FMPublicCellIconModel
+ (NSArray *)CellMenuItemArray{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CellMenuItem" ofType:@"plist"]];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[FMPublicCellIconModel modelWithJSON:dict]];
    }
    return arrayM;
}

@end
