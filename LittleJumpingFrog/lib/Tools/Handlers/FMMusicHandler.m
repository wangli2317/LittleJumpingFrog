//
//  FMMusicHandler.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/14.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMMusicHandler.h"
#import "FMMusicModel.h"
#import "FMMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation FMMusicHandler

+ (void)cacheMusicCoverWithMusicEntities:(NSArray *)musicEntities currentIndex:(NSInteger)currentIndex {
    NSInteger previoudsIndex = currentIndex-1;
    NSInteger nextIndex = currentIndex+1;
    previoudsIndex = previoudsIndex < 0 ? 0 : previoudsIndex;
    nextIndex = nextIndex == musicEntities.count ? musicEntities.count - 1 : nextIndex;
    NSMutableArray *indexArray = @[].mutableCopy;
    [indexArray addObject:[NSNumber numberWithInteger:previoudsIndex]];
    [indexArray addObject:[NSNumber numberWithInteger:nextIndex]];
    for (NSNumber *indexNum in indexArray) {

        FMMusicModel *music = musicEntities[indexNum.integerValue];
        NSURL *imageUrl = [NSURL URLWithString:music.songPicRadio];

        UIImage *image = [[YYWebImageManager sharedManager].cache getImageForKey:imageUrl.absoluteString withType:YYImageCacheTypeDisk];
        
        if (!image) {
            [[YYWebImageManager sharedManager] requestImageWithURL:imageUrl options:YYWebImageOptionUseNSURLCache progress:nil transform:nil completion:nil];
        }
    }
}

+ (void)configNowPlayingInfoCenter {
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        FMMusicModel *music = [FMMusicViewController sharedInstance].currentPlayingMusic;
        
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:music.songPicRadio] options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        
        [dict setObject:music.songName forKey:MPMediaItemPropertyTitle];
        [dict setObject:music.artistName forKey:MPMediaItemPropertyArtist];
        [dict setObject:[FMMusicViewController sharedInstance].musicTitle forKey:MPMediaItemPropertyAlbumTitle];
        [dict setObject:@(audioDurationSeconds) forKey:MPMediaItemPropertyPlaybackDuration];
        CGFloat playerAlbumWidth = (getScreenWidth() - 16) * 2;
        UIImageView *playerAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playerAlbumWidth, playerAlbumWidth)];
        playerAlbum.contentMode = UIViewContentModeScaleAspectFill;
        
        UIImage *placeholderImage = [UIImage imageNamed:@"music_lock_screen_placeholder"];
        NSURL *URL = [NSURL URLWithString:music.songPicRadio];
        
        [playerAlbum setImageWithURL:URL placeholder:placeholderImage options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (!image) {
                image = [UIImage new];
                image = placeholderImage;
            }
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
            [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }];
        
    }
}


@end
