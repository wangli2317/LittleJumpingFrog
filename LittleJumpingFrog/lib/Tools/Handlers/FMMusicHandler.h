//
//  FMMusicHandler.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/14.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMMusicHandler : NSObject

+ (void)cacheMusicCoverWithMusicEntities:(NSArray *)musicEntities currentIndex:(NSInteger)currentIndex;

+ (void)configNowPlayingInfoCenter;

@end
