//
//  FMPromptTool.h
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface FMPromptTool : NSObject

+ (void)promptModeText:(NSString *)text afterDelay:(NSInteger)time;

+ (MBProgressHUD *)promptModeIndeterminatetext:(NSString *)text;

@end
