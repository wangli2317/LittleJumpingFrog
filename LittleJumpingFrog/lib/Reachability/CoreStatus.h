//
//  CoreStatus.h
//  DTSmogi
//
//  Created by 王刚 on 16/11/30.
//  Copyright © 2016年 DTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "CoreNetWorkStatus.h"
#import "CoreStatusSingleton.h"
#import "CoreStatusProtocol.h"

@interface CoreStatus : NSObject
DTSSingletonH(CoreStatus)

+(CoreNetWorkStatus)currentNetWorkStatus;

/** 获取当前网络状态：字符串 */
+(NSString *)currentNetWorkStatusString;

/** 开始网络监听 */
+(void)beginNotiNetwork:(id<CoreStatusProtocol>)listener;

/** 停止网络监听 */
+(void)endNotiNetwork:(id<CoreStatusProtocol>)listener;

/** 是否是Wifi */
+(BOOL)isWifiEnable;

/** 是否有网络 */
+(BOOL)isNetworkEnable;

/** 是否处于高速网络环境：3G、4G、Wifi */
+(BOOL)isHighSpeedNetwork;


@end
