//
//  GVUserDefaults+Properties.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/14.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "GVUserDefaults.h"

typedef NS_ENUM(NSInteger, FMMusicCycleType) {
    MusicCycleTypeLoopAll = 0,
    MusicCycleTypeLoopSingle = 1,
    MusicCycleTypeShuffle = 2,
};

@interface GVUserDefaults (Properties)
@property (nonatomic, copy) NSString *userLoginToken;
@property (nonatomic, copy) NSString *userClientToken;
@property (nonatomic, copy) NSNumber *currentUserId;
@property (nonatomic, strong) NSDate *lastTimeShowLaunchScreenAd;
@property (nonatomic, assign) FMMusicCycleType musicCycleType;
@property (nonatomic, assign) BOOL shouldShowNotWiFiAlertView;
@end
