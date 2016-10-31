//
//  FMPlayMusicTool.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPlayMusicTool.h"
#import <NAKPlaybackIndicatorView.h>
#import <AVFoundation/AVFoundation.h>
#import "FMMusicIndicator.h"

#import "FMPlayerQueue.h"

@implementation FMPlayMusicTool

static FMMusicIndicator *_indicator;
static NSMutableDictionary *_playingMusic;

+ (void)initialize{
    _playingMusic = [NSMutableDictionary dictionary];
    _indicator = [FMMusicIndicator shareIndicator];
}

+ (void)setUpCurrentPlayingTime:(CMTime)time link:(NSString *)link{
    AVPlayerItem *playItem = _playingMusic[link];
    FMPlayerQueue *queue = [FMPlayerQueue sharePlayerQueue];
    [playItem seekToTime:time completionHandler:^(BOOL finished) {
        [_playingMusic setObject:playItem forKey:link];
        [queue play];
        _indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }];
}

+ (AVPlayerItem *)playMusicWithLink:(NSString *)link{
    FMPlayerQueue *queue = [FMPlayerQueue sharePlayerQueue];
    AVPlayerItem *playItem = _playingMusic[link];
    if (!playItem) {
        playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:link]];
        [_playingMusic setObject:playItem forKey:link];
        [queue replaceCurrentItemWithPlayerItem:playItem];
    }
    [queue play];
    _indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    return playItem;
}

+ (void)pauseMusicWithLink:(NSString *)link{
    AVPlayerItem *playItem = _playingMusic[link];
    if (playItem) {
        FMPlayerQueue *queue = [FMPlayerQueue sharePlayerQueue];
        [queue pause];
        _indicator.state = NAKPlaybackIndicatorViewStatePaused;
    }
}

+ (void)stopMusicWithLink:(NSString *)link{
    AVPlayerItem *playItem = _playingMusic[link];
    if (playItem) {
        FMPlayerQueue *queue = [FMPlayerQueue sharePlayerQueue];
        [_playingMusic removeAllObjects];
        [queue removeItem:playItem];
    }
}

@end
