//
//  Track.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/12.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"

@interface Track : NSObject <DOUAudioFile>
@property (nonatomic, strong) NSURL *audioFileURL;
@property (nonatomic, strong) NSURL *tempFileURL;
@property (nonatomic, strong) NSURL *cacheFileURL;
@end
