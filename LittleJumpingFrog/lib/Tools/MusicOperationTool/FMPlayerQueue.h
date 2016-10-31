//
//  FMPlayerQueue.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface FMPlayerQueue : AVQueuePlayer
+ (instancetype)sharePlayerQueue;
@end
