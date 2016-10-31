//
//  FMPromptTool.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/9/29.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "FMPromptTool.h"

@implementation FMPromptTool


+ (MBProgressHUD *)promptMode:(MBProgressHUDMode)mode text:(NSString *)text afterDelay:(NSInteger)time{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *prompt = [MBProgressHUD showHUDAddedTo:view animated:YES];
    prompt.userInteractionEnabled = NO;
    prompt.mode = mode;
    prompt.label.font = [UIFont systemFontOfSize:15];
    prompt.label.text = text;
    prompt.margin = 10.f;
    prompt.removeFromSuperViewOnHide = YES;
    [prompt hideAnimated:YES afterDelay:time];
    return prompt;
}

+ (void)promptModeText:(NSString *)text afterDelay:(NSInteger)time{
    [self promptMode:MBProgressHUDModeText text:text afterDelay:time];
}

+ (MBProgressHUD *)promptModeIndeterminatetext:(NSString *)text{
    return [self promptMode:MBProgressHUDModeIndeterminate text:text afterDelay:60];
}

@end
