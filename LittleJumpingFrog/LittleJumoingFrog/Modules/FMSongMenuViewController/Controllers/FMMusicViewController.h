//
//  FMMusicViewController.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/14.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "CustomViewController.h"
#import "DOUAudioStreamer.h"
#import "GVUserDefaults+Properties.h"
#import "FMMusicModel.h"

@protocol FMMusicViewControllerDelegate <NSObject>
@optional
- (void)updatePlaybackIndicatorOfVisisbleCells;
- (void)playMusicCellDataWithCurrentIndex:(NSInteger)currentIndex setupMusicEntity:(void (^)())setupMusicEntity;
@end

@interface FMMusicViewController : CustomViewController
@property (nonatomic, strong) NSMutableArray                *musicEntities;
@property (nonatomic, copy  ) NSString                      *musicTitle;
@property (nonatomic, strong) DOUAudioStreamer              *streamer;
@property (nonatomic, assign) BOOL                          dontReloadMusic;
@property (nonatomic, assign) NSInteger                     specialIndex;
@property (nonatomic, copy  ) NSNumber                      *parentId;
@property (nonatomic, assign) BOOL                          isNotPresenting;
@property (nonatomic, assign) FMMusicCycleType              musicCycleType;

@property (nonatomic, weak  ) id<FMMusicViewControllerDelegate> delegate;

+ (instancetype)sharedInstance;
- (void)playPreviousMusic:(id)sender;
- (void)playNextMusic:(id)sender;
- (FMMusicModel *)currentPlayingMusic;
@end

