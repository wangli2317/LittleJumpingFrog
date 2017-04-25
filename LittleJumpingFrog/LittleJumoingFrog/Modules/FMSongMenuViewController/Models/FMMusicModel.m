//
//  FMMusicModel.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMMusicModel.h"
#import "GYModelObject+DTSPersistentProperties.h"

@implementation FMMusicModel

+ (NSString *)dbName {
    return @"FMSongListDB";
}

+ (NSString *)tableName {
    return @"FMSongList";
}

+ (NSString *)primaryKey {
    return @"songId";
}

@end
