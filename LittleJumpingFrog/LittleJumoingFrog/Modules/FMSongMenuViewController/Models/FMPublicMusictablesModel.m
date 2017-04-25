//
//  FMPublicMusictablesModel.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/28.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPublicMusictablesModel.h"
#import "GYModelObject+DTSPersistentProperties.h"

@implementation FMPublicMusictablesModel

+ (NSString *)dbName {
    return @"FMSongListDB";
}

+ (NSString *)tableName {
    return @"FMPublicMusicList";
}

+ (NSString *)primaryKey {
    return @"listid";
}
@end
