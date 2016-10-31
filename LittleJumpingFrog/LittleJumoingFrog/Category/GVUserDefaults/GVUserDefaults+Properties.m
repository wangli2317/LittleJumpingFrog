//
//  GVUserDefaults+Properties.m
//  LittleJumpingFrog
//
//  Created by 王刚 on 16/10/14.
//  Copyright © 2016年 WangGang. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)

@dynamic userLoginToken;
@dynamic userClientToken;
@dynamic currentUserId;
@dynamic lastTimeShowLaunchScreenAd;
@dynamic musicCycleType;
@dynamic shouldShowNotWiFiAlertView;

- (NSDictionary *)setupDefaults{
    return @{@"shouldShowNotWiFiAlertView":@YES};
}

@end
