//
//  FMPlayMusicTool.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class FMPlayerQueue;

@interface FMPlayMusicTool : NSObject

+ (AVPlayerItem *)playMusicWithLink:(NSString *)link;

+ (void)pauseMusicWithLink:(NSString *)link;

+ (void)stopMusicWithLink:(NSString *)link;

+ (void)setUpCurrentPlayingTime:(CMTime)time link:(NSString *)link;
@end
